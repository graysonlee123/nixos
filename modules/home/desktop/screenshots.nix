{config, ...}: {
  programs.satty = {
    enable = true;
    settings = {
      general = {
        fullscreen = false;
        early-exit = false;
        initial-tool = "arrow";
        copy-command = "wl-copy";
        output-filename = "/tmp/screenshot-%Y-%m-%d_%H:%M:%S.png";
        save-after-copy = true;
        actions-on-enter = [
          "save-to-file"
          "exit"
        ];
        actions-on-right-click = [];
        actions-on-escape = ["exit"];
      };
      font = {
        family = config.stylix.fonts.sansSerif.name;
        style = "Regular";
      };
    };
  };
}
