{pkgs, ...}: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [thunar-archive-plugin thunar-volman thunar-vcs-plugin];
  };
  programs.xfconf.enable = true; # persist thunar prefs
  services.gvfs.enable = true; # davs://, sftp://, trash, mounts
  services.tumbler.enable = true; # thumbnails
}
