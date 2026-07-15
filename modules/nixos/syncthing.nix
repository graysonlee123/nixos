{ lib, config, ... }:

let
  syncthingData = import ../../data/syncthing.nix;
in
{
  sops.secrets = {
    "services/syncthing/password" = {
      owner = config.services.syncthing.user;
    };
  };

  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    guiPasswordFile = config.sops.secrets."services/syncthing/password".path;
    openDefaultPorts = true;
    settings = {
      devices = syncthingData.devices;
      folders = lib.mapAttrs (
        _: value:
        value
        // {
          path = "~/${value.id}";
          ignorePatterns = lib.splitString "\n" syncthingData.ignorePatterns;
        }
      ) syncthingData.folders;
      options.urAccepted = -1;
      gui.user = "gray";
    };
  };
}
