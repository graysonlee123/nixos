{
  inputs,
  pkgs-unstable,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs pkgs-unstable;};
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.nix-index-database.homeModules.default
    ];
  };
}
