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
          path = "${config.home.homeDirectory}/syncthing/${value.id}";
        }
      ) syncthingData.folders;
    };
  };

  systemd.user.tmpfiles.rules = lib.mapAttrsToList (
    name: value: "d %h/syncthing/${value.id}/.stfolder 0755"
  ) syncthingData.folders;

  home.file = (
    lib.mapAttrs' (
      name: value:
      lib.nameValuePair "syncthing/${value.id}/.stignore" {
        text = syncthingData.ignorePatterns;
      }
    ) syncthingData.folders
  );
}
