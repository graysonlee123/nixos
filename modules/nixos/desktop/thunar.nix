{pkgs, ...}: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [thunar-archive-plugin thunar-volman];
  };
  programs.xfconf.enable = true; # persist thunar prefs
  services.gvfs.enable = true; # davs://, sftp://, trash, mounts
  services.tumbler.enable = true; # thumbnails

  # Details view checks every subfolder for emptiness via a blocking enumerate
  # on the UI thread; over ftps:// that's one LIST per subfolder (~20s freeze).
  # Patch skips the check for non-local files.
  nixpkgs.overlays = [
    (_: prev: {
      thunar-unwrapped = prev.thunar-unwrapped.overrideAttrs (old: {
        patches = (old.patches or []) ++ [./thunar-remote-empty-dir.patch];
      });
    })
  ];

  # Backend for thunar-archive-plugin; plugin only ships wrappers for
  # file-roller/engrampa/ark (xarchiver's own wrapper isn't found)
  environment.systemPackages = [pkgs.file-roller];
}
