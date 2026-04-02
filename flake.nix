{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wttrbar.url = "github:graysonlee123/wttrbar?rev=74332e3fc5f170c9b174f72d7948eda5797e7be9";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, stylix, wttrbar, ... } @inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
    nixosConfigurations = {
      nostromo = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nostromo/configuration.nix
          stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default {
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; wttrbar = wttrbar.packages.x86_64-linux.default; };
          }
        ];
      };
      corbelan = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/corbelan/configuration.nix
          stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default {
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; wttrbar = wttrbar.packages.x86_64-linux.default; };
          }
        ];
      };
    };
  };
}
