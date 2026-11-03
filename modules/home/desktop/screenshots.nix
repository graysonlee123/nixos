{
  programs.satty = {
    enable = true;
    settings = {
      general = {
        fullscreen = false; # tiles in special:screenshot instead (hyprland.nix)
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
        family = "JetBrainsMono Nerd Font";
        style = "Regular";
      };
    };
  };
}
