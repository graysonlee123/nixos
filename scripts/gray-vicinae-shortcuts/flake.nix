{
  description = "Small Go program for populating Vicinae DB with shortcuts.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.buildGoModule {
        pname = "gray-vicinae-shortcuts";
        version = "0.1.0";
        src = ./.;
        vendorHash = "sha256-mOVKZV2zjmkcZQkFl4VDQApKTUE7QC4i7sTFJ/L5g1Q="; # or sha256 hash if using go.sum deps
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.go
          pkgs.gccgo
        ];
      };
    };
}
