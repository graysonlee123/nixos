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
    colmena = {
      url = "github:nix-community/colmena?ref=release-0.4.x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    stylix,
    colmena,
    wttrbar,
    sops-nix,
    nix-index-database,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    constants = import ./data/constants.nix;
    hosts = import ./data/hosts.nix;
    mkNode = {
      hostname,
      config,
      targetHost,
      isLaptop ? false,
      isHeadless ? false,
    }: {
      deployment = {
        inherit targetHost;
        targetUser = config.users.users.gray.name;
        allowLocalDeployment = true;
      };
      imports = [
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
            nix-index-database.homeModules.default
          ];
        }
      ];
    };
  in {
    nixosConfigurations = self.colmenaHive.nodes;
    formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
        specialArgs = {
          inherit
            constants
            hosts
            ;
        };
        nodeSpecialArgs = {
          nostromo = {
            isLaptop = false;
            isHeadless = false;
          };
          corbelan = {
            isLaptop = true;
            isHeadless = false;
          };
          sulaco = {
            isLaptop = false;
            isHeadless = true;
          };
        };
      };

      nostromo = {config, ...}:
        mkNode {
          inherit config;
          hostname = "nostromo";
          targetHost = null;
        };

      corbelan = {config, ...}:
        mkNode {
          inherit config;
          hostname = "corbelan";
          targetHost = null;
          isLaptop = true;
        };

      sulaco = {config, ...}:
        mkNode {
          inherit config;
          targetHost = "sulaco";
          hostname = "sulaco";
          isHeadless = true;
        };
    };
  };
}
