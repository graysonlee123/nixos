{
  description = "Grayson's NixOS configuration";

  inputs = {
    # https://github.com/NixOS/nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # https://github.com/nix-community/home-manager
    home-manager.url = "github:nix-community/home-manager?ref=release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/stylix
    stylix.url = "github:nix-community/stylix?ref=release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/graysonlee123/wttrbar
    wttrbar.url = "github:graysonlee123/wttrbar?ref=main";

    # https://github.com/Mic92/sops-nix
    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/colmena
    colmena.url = "github:nix-community/colmena?ref=release-0.4.x";
    colmena.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/nix-index-database
    nix-index-database.url = "github:nix-community/nix-index-database?ref=main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/nix-wrapper-modules
    wrappers.url = "github:nix-community/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    wrappers,
    ...
  }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # Static modules/files.
    constants = import ./data/constants.nix;
    hosts = import ./data/hosts.nix;
    wallpaperPathRaw = ./assets/images/space-scene-lofi.png;
    wallpaperPath = "${wallpaperPathRaw}";

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
        wrappers.nixosModules.niri
        ({inputs, ...}: {
          # Colmena skips lib.nixosSystem, which normally sets this. Points
          # NIX_PATH + registry `nixpkgs` at the pinned input (comma needs it).
          nixpkgs.flake.source = nixpkgs;

          home-manager.extraSpecialArgs =
            {
              inherit
                inputs
                pkgs-unstable
                isLaptop
                isHeadless
                constants
                hosts
                wallpaperPathRaw
                wallpaperPath
                ;
            }
            // lib.optionalAttrs (!isHeadless) {
              wttrbar = wttrbar.packages.${system}.default;
            };
          home-manager.sharedModules = [
            sops-nix.homeManagerModules.sops
            nix-index-database.homeModules.default
          ];
        })
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
            inherit constants hosts pkgs-unstable;
            inputs = self.inputs;
            wlib = wrappers.lib;
          };
          nodeSpecialArgs =
            lib.mapAttrs (_: node: {
              inherit (node) isLaptop isHeadless;
              inherit
                wallpaperPathRaw
                wallpaperPath
                ;
            })
            nodes;
        };
      }
      // lib.mapAttrs mkNode nodes
    );
  };
}
