{ config, lib, pkgs, ... }:

let
  cfg = config.waybar;
in {
  options.waybar = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable laptop-specific waybar configurations.";
    };
  };

  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
          modules-right = [ "custom/dictation" "cava" "custom/music" "custom/weather" ] ++ lib.optional cfg.isLaptop "battery" ++ [ "cpu" "memory" "network" "wireplumber" "wireplumber#source" "clock" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };

          "sway/window" = {
            max-length = 50;
            # Suppresses a waybar warning: "'swap-icon-label' must be a bool"
            swap-icon-label = false;
          };

          "battery" = {
            format = "{icon} {capacity}%";
            format-icons = {
              default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
              charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
            };
          };

          "cpu" = {
            format = "󰻠 {usage}%";
            tooltip = false;
          };

          "memory" = {
            format = "  {}%";
          };

          "network" = {
            format-wifi = "󰖩 {essid}";
            format-ethernet = "󰈀 {ipaddr}";
            format-disconnected = "⚠ Disconnected";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          };

          "wireplumber" = {
            format = "{icon} {volume}%";
            format-muted = "󰣽";
            format-icons = {
              default = [ "󰣴" "󰣶" "󰣸" "󰣺" ];
            };
            scroll-step = 5;
            on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
            on-click-right = "/home/gray/.nix-profile/bin/ghostty -e /home/gray/.nix-profile/bin/wiremix";
          };

          "wireplumber#source" = {
            node-type = "Audio/Source";
            format = "󰍬 {volume}%";
            format-muted = "󰍭";
            scroll-step = 5;
            on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
            on-click-right = "/home/gray/.nix-profile/bin/ghostty -e /home/gray/.nix-profile/bin/wiremix --tab input";
          };

          "clock" = {
            format = "󰃭 {0:%m/%d} {0:%I:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "custom/music" = {
            hide-empty-text = true;
            interval = 2; # TODO: Use signals to update?
            max-length = 32;
            exec = ''
              ${pkgs.playerctl}/bin/playerctl metadata --format '  {{title}} - {{artist}}'
            '';
            on-click = ''
              ${pkgs.playerctl}/bin/playerctl play-pause
            '';
            tooltip = true;
            tooltip-format = ""; # TODO: Show more metadata
          };

          "cava" = {
            method = "pipewire";
            bars = 7;
            format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
            bar_delimiter = 0;
            hide_on_silence = true;
          };
        };
      };

      style = ''
        #workspaces button {
          padding: 0 5px;
        }

        #clock,
        #cpu,
        #memory,
        #network,
        #wireplumber,
        #battery,
        #custom-dictation,
        #custom-weather,
        #custom-music,
        #window,
        #mode {
          padding: 0 10px;
        }
      '';
    };

    # Kill any existing waybar before starting to prevent duplicate bars on
    # resume from suspend. The leading "-" tells systemd to ignore non-zero
    # exit codes (i.e. when no waybar process exists to kill).
    systemd.user.services.waybar = {
      Service.ExecStartPre = "-${pkgs.procps}/bin/pkill -x waybar";
    };
  };
}
