{ lib, ... }:

{
  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = lib.mkDefault 14;
        theme = "rose-pine-moon";
        shell-integration-features = "ssh-env";
      };
      themes = {
        rose-pine-moon = {
          background = "191724";
          foreground = "e0def4";
          cursor-color = "e0def4";
          cursor-text = "191724";
          palette = [
            "0=#26233a"
            "1=#eb6f92"
            "2=#31748f"
            "3=#f6c177"
            "4=#9ccfd8"
            "5=#c4a7e7"
            "6=#ebbcba"
            "7=#e0def4"
            "8=#6e6a86"
            "9=#eb6f92"
            "10=#31748f"
            "11=#f6c177"
            "12=#9ccfd8"
            "13=#c4a7e7"
            "14=#ebbcba"
            "15=#e0def4"
          ];
          selection-background = "403d52";
          selection-foreground = "e0def4";
        };
      };
    };
  };
}
