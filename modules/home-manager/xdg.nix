{
  xdg.desktopEntries.yazi-open = {
    name = "Yazi";
    comment = "Terminal file manager";
    exec = "ghostty -e yazi %u";
    terminal = false;
    mimeType = [ "inode/directory" ];
    categories = [ "Utility" "FileManager" ];
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    # Directories
    "inode/directory" = "yazi-open.desktop";
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
}

