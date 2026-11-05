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
    sops-nix = {
      url = "github:Mic92/sops-nix?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:nix-community/colmena?ref=release-0.4.x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.57.1";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    colmena,
    wttrbar,
    sops-nix,
    nix-index-database,
    ...
  }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    constants = import ./data/constants.nix;
    hosts = import ./data/hosts.nix;

    # Hive nodes. targetHost = null: skipped by `colmena apply`, rebuilt locally.
    nodes = lib.mapAttrs (_: node:
      {
        isLaptop = false;
        isHeadless = false;
      }
      // node) {
      nostromo.targetHost = null;
      corbelan = {
        targetHost = null;
        isLaptop = true;
      };
      sulaco = {
        # SSH alias (not IP) so HM ssh config supplies key/user/host
        targetHost = "sulaco";
        isHeadless = true;
      };
    };

    mkNode = name: {
      targetHost,
      isLaptop,
      isHeadless,
    }: {config, ...}: {
      deployment = {
        inherit targetHost;
        targetUser = config.users.users.gray.name;
        allowLocalDeployment = true;
      };
      imports = [
        ./hosts/${name}/configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.default
        sops-nix.nixosModules.sops
        {
          # Colmena skips lib.nixosSystem, which normally sets this. Points
          # NIX_PATH + registry `nixpkgs` at the pinned input (comma needs it).
          nixpkgs.flake.source = nixpkgs;

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
            // lib.optionalAttrs (!isHeadless) {
              wttrbar = wttrbar.packages.${system}.default;
            };
          home-manager.sharedModules = [
            sops-nix.homeManagerModules.sops
            nix-index-database.homeModules.default
          ];
        }
      ];
    };
  in {
    nixosConfigurations = self.colmenaHive.nodes;
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    colmenaHive = colmena.lib.makeHive (
      {
        meta = {
          nixpkgs = import nixpkgs {inherit system;};
          specialArgs = {
            inherit constants hosts;
            inputs = self.inputs;
          };
          nodeSpecialArgs = lib.mapAttrs (_: node: {inherit (node) isLaptop isHeadless;}) nodes;
        };
      }
      // lib.mapAttrs mkNode nodes
    );
  };
}
