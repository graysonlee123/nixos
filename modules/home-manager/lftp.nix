{ config, ... }:

let
  syncthingDir = config.services.syncthing.settings.folders.Personal.path;
in
{
  # The benefit of the Syncthing approach is that each change to the high-velocity
  # bookmarks file doesn't need to be modified and committed in git.
  home.file.".local/share/lftp/bookmarks".source =
    config.lib.file.mkOutOfStoreSymlink "${syncthingDir}/lftp/bookmarks";
  home.file.".config/lftp/rc".text = ''
    set cmd:default-protocol sftp
    set cmd:ls-default -l
    set cmd:prompt ---\n\h:\w\n\s (v\v)\>\ 
  '';
}
