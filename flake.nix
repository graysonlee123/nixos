{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stylix, ... } @inputs:
    let
      system = "x86_64-linux";
    in
    {
    nixosConfigurations = {
      nostromo = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nostromo/configuration.nix
          stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
        ];
      };
      corbelan = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/corbelan/configuration.nix
          stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
