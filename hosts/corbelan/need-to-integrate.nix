{ config, pkgs, ... }:

{

  home-manager.users.gray = { pkgs, ... }: {
    programs.ghostty = {
      settings = {
        font-size = 10;
      };
    };

    # Laptop brightness controls
    wayland.windowManager.sway.config.keybindings = {
    };

    programs.waybar.settings.mainBar = {
      modules-right = [ "battery" ];
    };
  };
}
