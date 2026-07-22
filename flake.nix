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
    wttrbar.url = "github:graysonlee123/wttrbar?rev=5268867aad69899f016f9c2cc7ecab3f655f4e13";
    sops-nix = {
      url = "github:Mic92/sops-nix?rev=56b24064fdcaedca53553b1a6d607fd23b613a24";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      stylix,
      wttrbar,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nostromo =
          let
            isLaptop = false;
            isHeadless = false;
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit isLaptop isHeadless;
            };
            modules = [
              ./hosts/nostromo/configuration.nix
              stylix.nixosModules.stylix
              inputs.home-manager.nixosModules.default
              sops-nix.nixosModules.sops
              {
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable isLaptop isHeadless;
                  wttrbar = wttrbar.packages.x86_64-linux.default;
                };
                home-manager.sharedModules = [
                  sops-nix.homeManagerModules.sops
                ];
              }
            ];
          };
        corbelan =
          let
            isLaptop = true;
            isHeadless = false;
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit isLaptop isHeadless;
            };
            modules = [
              ./hosts/corbelan/configuration.nix
              stylix.nixosModules.stylix
              inputs.home-manager.nixosModules.default
              sops-nix.nixosModules.sops
              {
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable isLaptop isHeadless;
                  wttrbar = wttrbar.packages.x86_64-linux.default;
                };
                home-manager.sharedModules = [
                  sops-nix.homeManagerModules.sops
                ];
              }
            ];
          };
        sulaco =
          let
            isLaptop = false;
            isHeadless = true;
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit isLaptop isHeadless;
            };
            modules = [
              ./hosts/sulaco/configuration.nix
              stylix.nixosModules.stylix
              inputs.home-manager.nixosModules.default
              sops-nix.nixosModules.sops
              {
                home-manager.extraSpecialArgs = {
                  inherit pkgs-unstable isLaptop isHeadless;
                };
                home-manager.sharedModules = [
                  sops-nix.homeManagerModules.sops
                ];
              }
            ];
          };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
