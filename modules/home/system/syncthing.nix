{
  lib,
  config,
  ...
}: let
  syncthingData = import ../../../data/syncthing.nix;
in {
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings = {
      devices = syncthingData.devices;
      folders =
        lib.mapAttrs (
          _: value:
            value
            // {
              path = "${config.home.homeDirectory}/syncthing/${value.id}";
            }
        )
        syncthingData.folders;
    };
  };

  systemd.user.tmpfiles.rules =
    lib.mapAttrsToList (
      name: value: "d %h/syncthing/${value.id}/.stfolder 0755"
    )
    syncthingData.folders;

  # Syncthing refuses to follow a symlinked .stignore (rooted FS reports
  # ELOOP), so write real files instead of home.file symlinks.
  home.activation.syncthingIgnores = lib.hm.dag.entryAfter ["writeBoundary"] (
    let
      stignore = builtins.toFile "stignore" syncthingData.ignorePatterns;
    in
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: value: ''run install -Dm644 ${stignore} "${config.home.homeDirectory}/syncthing/${value.id}/.stignore"''
        )
        syncthingData.folders
      )
  );
}
