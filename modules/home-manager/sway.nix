{ config, lib, pkgs, ... }:

let
  cfg = config.sway;
  recordScreen = pkgs.writeShellScriptBin "record-screen" ''
    if pgrep -x wf-recorder > /dev/null; then
      pkill -SIGINT wf-recorder
      exit 0
    fi

    choice=$(printf "Record region\nRecord region + audio\nRecord fullscreen\nRecord fullscreen + audio" \
      | vicinae dmenu -n "Screen Recording" -p "Select action...")

    FILE=/tmp/video-$(date +%Y-%m-%d_%H-%M-%S).mp4

    case "$choice" in
      "Record region")
        wf-recorder -g "$(slurp)" --file "$FILE" && notify-send "Recording saved" "$FILE" ;;
      "Record region + audio")
        wf-recorder -g "$(slurp)" --audio --file "$FILE" && notify-send "Recording saved" "$FILE" ;;
      "Record fullscreen")
        wf-recorder --file "$FILE" && notify-send "Recording saved" "$FILE" ;;
      "Record fullscreen + audio")
        wf-recorder --audio --file "$FILE" && notify-send "Recording saved" "$FILE" ;;
    esac
  '';
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
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      config = let
        modifier = "Mod4";
      in {
        modifier = modifier;
        terminal = "ghostty";

        # Output configuration
        output = if (cfg.isLaptop) then {
          "eDP-1" = {
            position = "0,540";
            scale = "2";
          };
          "HDMI-A-1" = {
            position = "1440,0";
          };
        } else {
          "DP-1" = {
            position = "1080,160";
          };
          "HDMI-A-1" = {
            transform = "270";
            position = "0,0";
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
          "${modifier}+Shift+l" = "exec swaymsg exit";

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
          "${modifier}+h" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+f" = "fullscreen";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";

          # Modes
          "${modifier}+r" = "mode resize";
          "${modifier}+slash" = "mode launch";

          # Vicinae
          "${modifier}+d" = "exec vicinae toggle";

          # Screenshots
          "Print" = "exec grim -g \"$(slurp -b '#00000099' -c '#00ff41')\" - | satty --filename -";

          # Recordings
          "${modifier}+Print" = "exec record-screen";
        } // lib.optionalAttrs cfg.isLaptop {
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
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
          launch = {
            "1" = "exec sh -c '1password && swaymsg mode default'";
            "c" = "exec sh -c 'chromium && swaymsg mode default'";
            "o" = "exec sh -c 'obsidian && swaymsg mode default'";
            "t" = "exec sh -c 'ghostty && swaymsg mode default'";
            "d" = "exec discord; mode default";
            "v" = "exec sh -c 'code && swaymsg mode default'";
            "p" = "exec phpstorm; mode default";
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

        # Workspace output assignments
        workspaceOutputAssign = if (!cfg.isLaptop) then [
          { workspace = "1"; output = "DP-1"; }
          { workspace = "2"; output = "DP-1"; }
          { workspace = "3"; output = "DP-1"; }
          { workspace = "4"; output = "HDMI-A-1"; }
          { workspace = "5"; output = "HDMI-A-1"; }
        ] else [
          { workspace = "1"; output = "HDMI-A-1"; }
          { workspace = "2"; output = "HDMI-A-1"; }
          { workspace = "3"; output = "HDMI-A-1"; }
          { workspace = "4"; output = "eDP-1"; }
          { workspace = "5"; output = "eDP-1"; }
        ];

        # Startup
        startup = lib.mkMerge [
          [
            {
              command = "vicinae server --replace";
              always = true;
            }
          ]

          (lib.mkIf (!cfg.isLaptop) [
            {
              command = "swaymsg workspace 4";
            }
            {
              command = "swaymsg workspace 1";
            }
          ])

          (lib.mkIf cfg.isLaptop [
            {
              command = "swaymsg workspace 4";
            }
            {
              command = "swaymsg workspace 1";
            }
          ])
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
          {
            criteria = { app_id = "^io\\.github\\.waylyrics\\.Waylyrics$"; };
            command = "floating enable";
          }
          {
            criteria = { title = "^ATLauncher Console$"; };
            command = "floating enable";
          }
          {
            criteria = { app_id = "^code$"; title = "- Chromium$"; };
            command = "floating enable";
          }
          {
            criteria = { app_id = "^vesktop$"; };
            command = "move window workspace 4";
          }
          {
            criteria = { class = "^tidal-hifi$"; };
            command = "move window workspace 5";
          }
        ];
      };
    };

    home.packages = [ recordScreen ];
  };
}
