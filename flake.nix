{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager?ref=release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:nix-community/stylix?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wttrbar.url = "github:graysonlee123/wttrbar?ref=main";
    # Follow nixpkgs-unstable (not nixos-26.05): OpenLogi's rust build needs
    # unstable rustc (26.05 lags workspace rust-version). rust-overlay stays.
    openlogi = {
      url = "github:AprilNEA/OpenLogi/a92aa43bed3732be5f7fde7aed2fc12cc48ba001";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    stylix,
    wttrbar,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    constants = import ./data/constants.nix;
    hosts = import ./data/hosts.nix;
    mkHost = {
      hostname,
      isLaptop ? false,
      isHeadless ? false,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            isLaptop
            isHeadless
            constants
            hosts
            ;
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.default
          sops-nix.nixosModules.sops
          inputs.openlogi.nixosModules.default
          {
            home-manager.extraSpecialArgs =
              {
                inherit
                  pkgs-unstable
                  isLaptop
                  isHeadless
                  constants
                  hosts
                  ;
              }
              // nixpkgs.lib.optionalAttrs (!isHeadless) {
                wttrbar = wttrbar.packages.x86_64-linux.default;
              };
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
  in {
    nixosConfigurations = {
      nostromo = mkHost {
        hostname = "nostromo";
      };
      corbelan = mkHost {
        hostname = "corbelan";
        isLaptop = true;
      };
      sulaco = mkHost {
        hostname = "sulaco";
        isHeadless = true;
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixfmt-tree;
  };
}
