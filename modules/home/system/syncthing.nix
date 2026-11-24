{
  osConfig,
  config,
  lib,
  ...
}: let
  syncthingData = import ../../../data/syncthing.nix {hosts = osConfig.lan.hosts;};
  home = config.home.homeDirectory;

  # `homePath` (relative to $HOME) overrides the default ~/syncthing/<id>.
  folders =
    lib.mapAttrs (
      _: value:
        removeAttrs value ["homePath"]
        // {
          path = "${home}/${value.homePath or "syncthing/${value.id}"}";
        }
    )
    syncthingData.folders;
in {
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    settings = {
      inherit folders;
      devices = syncthingData.devices;
    };
  };

  systemd.user.tmpfiles.rules =
    lib.mapAttrsToList (
      _: value: "d ${value.path}/.stfolder 0755"
    )
    folders;

  # Syncthing refuses to follow a symlinked .stignore (rooted FS reports
  # ELOOP), so write real files instead of home.file symlinks.
  home.activation.syncthingIgnores = lib.hm.dag.entryAfter ["writeBoundary"] (
    let
      stignore = builtins.toFile "stignore" syncthingData.ignorePatterns;
    in
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          _: value: ''run install -Dm644 ${stignore} "${value.path}/.stignore"''
        )
        folders
      )
  );
}
