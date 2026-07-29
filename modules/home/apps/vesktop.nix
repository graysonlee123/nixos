{
  programs.vesktop = {
    enable = true;
    settings = {
      autoStartMinimized = false;
      checkUpdates = false;
      discordBranch = "stable";
      minimizeToTray = false;
      tray = false;
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
