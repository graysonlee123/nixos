{
  lib,
  config,
  ...
}:

let
  syncthingData = import ../../data/syncthing.nix;
in
{
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings = {
      devices = syncthingData.devices;
      folders = lib.mapAttrs (
        _: value:
        value
        // {
          path = "${config.home.homeDirectory}/syncthing";
        }
      ) syncthingData.folders;
    };
  };

  home.file."syncthing/.stignore".text = syncthingData.ignorePatterns;
}
