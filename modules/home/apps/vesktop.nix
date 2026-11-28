{pkgs-unstable, ...}: {
  programs.vesktop = {
    enable = true;
    # Unstable: Vencord auto-updates at runtime; stable Vesktop's screenshare
    # picker uses components newer Vencord removed (HeadingTertiary), crashing
    # on Go Live. Keep Vesktop current to match.
    package = pkgs-unstable.vesktop;
    settings = {
      autoStartMinimized = false;
      checkUpdates = false;
      discordBranch = "stable";
      minimizeToTray = false;
      tray = false;
    };
    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = false;
      disableMinSize = true;
      plugins = {
        ClearURLs.enabled = true;
        CopyFileContents.enabled = true;
        FriendsSince.enabled = true;
        oneko.enabled = true;
        MentionAvatars.enabled = true;
        MessageLogger.enabled = true;
        petpet.enabled = true;
        PlainFolderIcon.enabled = true;
        PlatformIndicators.enabled = true;
        RelationshipNotifier.enabled = true;
        WhoReacted.enabled = true;
      };
    };
  };
}
