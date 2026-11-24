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
    wttrbar.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/Mic92/sops-nix
    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/colmena
    colmena.url = "github:nix-community/colmena?ref=v0.5.0";
    colmena.inputs.nixpkgs.follows = "nixpkgs-unstable";
    colmena.inputs.stable.follows = "nixpkgs";

    # https://github.com/nix-community/nix-index-database
    nix-index-database.url = "github:nix-community/nix-index-database?ref=main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/nix-community/nix-wrapper-modules
    wrappers.url = "github:nix-community/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # NixOS hosts. Values turn into target host for colmena.
    mainHosts = {
      nostromo = null;
      corbelan = null;
      sulaco = "sulaco";
    };

    # Make a node module, given a name and target host.
    mkNode = name: targetHost: {config, ...}: {
      deployment = {
        inherit targetHost;
        targetUser = config.users.users.gray.name;
        allowLocalDeployment = true;
      };
      imports = [./hosts/${name}/configuration.nix];
    };
  in {
    nixosConfigurations = inputs.self.colmenaHive.nodes;
    formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.alejandra;
    colmenaHive = inputs.colmena.lib.makeHive (
      {
        meta = {
          nixpkgs = import inputs.nixpkgs {inherit system;};
          specialArgs = {
            inherit inputs pkgs-unstable;
          };
        };
        defaults = _: {
          imports = [
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            inputs.wrappers.nixosModules.niri
          ];
        };
      }
      // inputs.nixpkgs.lib.mapAttrs mkNode mainHosts
    );
  };
}
