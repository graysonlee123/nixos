{
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      tray = false;
      minimizeToTray = false;
      autoStartMinimized = false;
    };
    vencord.settings = {
      autoUpdate = false;
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
