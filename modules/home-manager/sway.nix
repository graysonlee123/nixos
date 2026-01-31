{ config, lib, ... }:

let
  cfg = config.sway;
in {
  options.sway = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable laptop-specific sway configurations.";
    };
  };

  config = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = let
        modifier = "Mod4";
      in {
        modifier = modifier;
        terminal = "ghostty";

        # Output configuration
        output = lib.mkIf cfg.isLaptop {
          "eDP-1" = {
            position = "0,540";  # 540 = 1440 - 900 (align to bottom)
            scale = "2";
          };
          "HDMI-A-1" = {
            position = "1440,0";
          };
        };

        # Lid switch - disable laptop display when lid is closed
        bindswitches = lib.mkIf cfg.isLaptop {
          "lid:on" = {
            action = "output eDP-1 disable";
          };
          "lid:off" = {
            action = "output eDP-1 enable";
          };
        };

        # Keybindings
        keybindings = {
          # Launch terminal
          "${modifier}+Return" = "exec ghostty";

          # Kill focused window
          "${modifier}+Shift+q" = "kill";

          # Reload configuration
          "${modifier}+Shift+c" = "reload";

          # Exit sway
          "${modifier}+Shift+e" = "exec swaymsg exit";

          # Movement focus
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move focused window
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # Workspaces
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          # Move container to workspace
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          # Layout
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+f" = "fullscreen";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";

          # Resize mode
          "${modifier}+r" = "mode resize";

          # Vicinae
          "${modifier}+d" = "exec vicinae toggle";

          # Screenshots
          "Print" = "exec grim -g \"$(slurp -b '#00000099' -c '#00ff41')\" - | satty --filename - --fullscreen";
        } // lib.optionalAttrs cfg.isLaptop {
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        };

        # Resize mode keybindings
        modes = {
          resize = {
            "Left" = "resize shrink width 10px";
            "Down" = "resize grow height 10px";
            "Up" = "resize shrink height 10px";
            "Right" = "resize grow width 10px";
            "h" = "resize shrink width 10px";
            "j" = "resize grow height 10px";
            "k" = "resize shrink height 10px";
            "semicolon" = "resize grow width 10px";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };

        # Inputs
        input = {
          "type:keyboard" = {
            repeat_rate = "75";
            repeat_delay = "200";
          };
          "1133:49291:Logitech_G502_HERO_Gaming_Mouse" = {
            accel_profile = "flat";
            pointer_accel = "0.3";
          };
        };

        # Disable default bar (using Waybar instead)
        bars = [];

        # Colors for window borders - ALIEN (1979) TERMINAL THEME
        colors = {
          focused = {
            border = "#00ff41";        # Bright phosphor green border
            background = "#0a0e0a";    # Almost black background
            text = "#00ff41";          # Phosphor green text
            indicator = "#33ff33";     # Bright green indicator
            childBorder = "#00ff41";   # Phosphor green child border
          };
          focusedInactive = {
            border = "#003300";        # Dark green border
            background = "#0a0e0a";    # Almost black background
            text = "#009900";          # Dimmed green text
            indicator = "#006600";     # Dim green indicator
            childBorder = "#003300";   # Dark green child border
          };
          unfocused = {
            border = "#001a00";        # Very dark green border
            background = "#0a0e0a";    # Almost black background
            text = "#004400";          # Very dim green text
            indicator = "#003300";     # Very dim indicator
            childBorder = "#001a00";   # Very dark green child border
          };
          urgent = {
            border = "#ff6600";        # Warning amber border
            background = "#331100";    # Dark amber background
            text = "#ffaa00";          # Amber warning text
            indicator = "#ff3300";     # Red alert indicator
            childBorder = "#ff6600";   # Warning amber child border
          };
        };

        # Startup
        startup = [
          {
            command = "swaymsg workspace number 1";
          }
          {
            command = "vicinae server";
            always = true;
          }
        ];

        # Window rules
        window.commands = [
          {
            criteria = { app_id = "^mako$"; };
            command = "floating enable, border none";
          }
          {
            criteria = { title = "Picture in picture"; };
            command = "floating enable, sticky enable";
          }
          {
            criteria = { title = "^1Password$"; };
            command = "floating enable; sticky enable";
          }
        ];
      };
    };
  };
}
