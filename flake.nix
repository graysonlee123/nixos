{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @inputs:
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
          inputs.home-manager.nixosModules.default
        ];
      };
      corbelan = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/corbelan/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
