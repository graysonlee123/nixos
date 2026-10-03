{config, ...}: {
  xdg.desktopEntries.yazi-open = {
    name = "Yazi";
    comment = "Terminal file manager";
    exec = "ghostty -e yazi %f";
    terminal = false;
    mimeType = ["inode/directory"];
    categories = [
      "Utility"
      "FileManager"
    ];
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    # Directories
    "inode/directory" = "thunar.desktop";
    # Video
    "video/mp4" = "vlc.desktop";
    "video/x-matroska" = "vlc.desktop";
    "video/webm" = "vlc.desktop";
    "video/avi" = "vlc.desktop";

    # Audio
    "audio/flac" = "vlc.desktop";
    "audio/mpeg" = "vlc.desktop";
    "audio/mp4" = "vlc.desktop";
    "audio/wav" = "vlc.desktop";
    "audio/webm" = "vlc.desktop";
    "audio/ogg" = "vlc.desktop";

    # Images
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";

    # Documents
    "application/pdf" = "chromium-browser.desktop";

    # Text/code
    "text/plain" = "vim.desktop";
    "text/markdown" = "vim.desktop";
    "text/html" = "chromium-browser.desktop";
    "text/x-shellscript" = "vim.desktop";
    "application/json" = "vim.desktop";
    "application/xml" = "vim.desktop";
  };

  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
    desktop = "${config.home.homeDirectory}/desktop";
    documents = "${config.home.homeDirectory}/documents";
    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/music";
    pictures = "${config.home.homeDirectory}/pictures";
    publicShare = "${config.home.homeDirectory}/public";
    templates = "${config.home.homeDirectory}/templates";
    videos = "${config.home.homeDirectory}/videos";
  };

  # File manager sidebar (Thunar, GTK file pickers)
  gtk.gtk3.bookmarks = [
    "file://${config.xdg.userDirs.download} Downloads"
    "file://${config.xdg.userDirs.documents} Documents"
    "file://${config.xdg.userDirs.pictures} Pictures"
    "file://${config.home.homeDirectory}/syncthing Syncthing"
    "file://${config.home.homeDirectory}/repos Repos"
    "file:///tmp Temp"
    "file:///run/current-system/sw System packages"
    "file://${config.home.homeDirectory}/.nix-profile User packages"
    "file://${config.home.homeDirectory}/.local/state/home-manager/gcroots/current-home Home Manager"
    "file://${config.home.homeDirectory}/repos/me/nixos NixOS"
    "file://${config.home.homeDirectory}/repos/inspry/checkview Checkview"
    "file://${config.home.homeDirectory}/repos/inspry/helper Helper Plugin"
  ];
  # GTK replaces the symlink with a real file when bookmarks change in the UI
  xdg.configFile."gtk-3.0/bookmarks".force = true;
}
