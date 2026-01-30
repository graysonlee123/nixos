{ config, pkgs, ... }:

{

  home-manager.users.gray = { pkgs, ... }: {
    # Laptop-specific packages
    home.packages = with pkgs; [
      brightnessctl
    ];

    programs.ghostty = {
      settings = {
        font-size = 10;
      };
    };

    # Laptop brightness controls
    wayland.windowManager.sway.config.keybindings = {
      "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
      "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
    };

    programs.waybar.settings.mainBar = {
      modules-right = [ "battery" ];
    };
  };
}
