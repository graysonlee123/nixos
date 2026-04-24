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
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          fixed-center = false;

          modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
          modules-right = [ "custom/dictation" "custom/music" "custom/weather" "cpu" "memory" "custom/mullvad" "group/network-group" "group/audio-group" ] ++ lib.optional cfg.isLaptop "battery" ++ [ "clock" ];

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

          "group/network-group" = {
            orientation = "horizontal";
            modules = [ "group/network-drawer" "network" ];
          };

          "group/network-drawer" = {
            orientation = "horizontal";
            modules = [ "custom/network-btn" "network#bandwidth" "custom/bandwhich-btn" "custom/nload-btn" "custom/nmtui-btn" ];
            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
              click-to-reveal = true;
            };
          };

          "custom/network-btn" = {
            format = "󰅁";
            tooltip = false;
          };

          "network" = {
            format-wifi = "󰖩 {essid}";
            format-ethernet = "󰈀 {ipaddr}";
            format-disconnected = "⚠ Disconnected";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          };

          "network#bandwidth" = {
            format-wifi = "↓{bandwidthDownBytes} ↑{bandwidthUpBytes}";
            format-ethernet = "↓{bandwidthDownBytes} ↑{bandwidthUpBytes}";
            format-disconnected = "";
            tooltip = false;
            interval = 2;
          };

          "custom/bandwhich-btn" = {
            format = "[bandwhich]";
            tooltip = false;
            on-click = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.bash}/bin/bash -c '/run/wrappers/bin/sudo ${pkgs.bandwhich}/bin/bandwhich'";
          };

          "custom/nload-btn" = {
            format = "[nload]";
            tooltip = false;
            on-click = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.nload}/bin/nload";
          };

          "custom/nmtui-btn" = {
            format = "[nmtui]";
            tooltip = false;
            on-click = "${pkgs.ghostty}/bin/ghostty -e /run/current-system/sw/bin/nmtui";
          };

          "group/audio-group" = {
            orientation = "horizontal";
            modules = [ "group/audio-drawer" "wireplumber" "wireplumber#source" ];
          };

          "group/audio-drawer" = {
            orientation = "horizontal";
            modules = [ "custom/audio-btn" "custom/wiremix-btn" "custom/pavucontrol-btn" ];
            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
              click-to-reveal = true;
            };
          };

          "custom/audio-btn" = {
            format = "󰅁";
            tooltip = false;
          };

          "wireplumber" = {
            format = "{icon} {volume}%";
            format-muted = "󰣽 [m]";
            format-icons = {
              default = [ "󰣴" "󰣶" "󰣸" "󰣺" ];
            };
            scroll-step = 5;
            on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          };

          "wireplumber#source" = {
            node-type = "Audio/Source";
            format = "󰍬 {volume}%";
            format-muted = "󰍭 [m]";
            scroll-step = 5;
            on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
          };

          "custom/wiremix-btn" = {
            format = "[wiremix]";
            tooltip = false;
            on-click = "${pkgs.ghostty}/bin/ghostty -e /home/gray/.nix-profile/bin/wiremix";
            on-click-right = "${pkgs.ghostty}/bin/ghostty -e /home/gray/.nix-profile/bin/wiremix --tab input";
          };

          "custom/pavucontrol-btn" = {
            format = "[pavucontrol]";
            tooltip = false;
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          "clock" = {
            format = "󰃭 {0:%m/%d} {0:%I:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "custom/music" = {
            hide-empty-text = true;
            interval = 2; # TODO: Use signals to update?
            max-length = if cfg.isLaptop then 32 else 64;
            escape = true;
            exec = ''
              ${pkgs.playerctl}/bin/playerctl metadata --format '  {{title}} - {{artist}}'
            '';
            on-click = ''
              ${pkgs.playerctl}/bin/playerctl play-pause
            '';
            tooltip = true;
            tooltip-format = ""; # TODO: Show more metadata
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
        #battery,
        #custom-dictation,
        #custom-weather,
        #custom-music,
        #window,
        #mode {
          padding: 0 10px;
        }

        #network,
        #wireplumber,
        #custom-network-btn,
        #custom-audio-btn,
        #custom-bandwhich-btn,
        #custom-nload-btn,
        #custom-nmtui-btn,
        #custom-wiremix-btn,
        #custom-pavucontrol-btn {
          padding: 0 5px;
        }

        /* Waybar sets STATE_FLAG_PRELIGHT (mapped to :hover in GTK CSS) on the
           group box when the drawer is open — there is no .open class. */
        #network-drawer:hover,
        #audio-drawer:hover {
          background-color: rgba(255, 255, 255, 0.05);
        }

        #network-group,
        #audio-group {
          border-radius: 4px;
          padding: 0 4px;
        }

        #network-group {
          background-color: rgba(100, 180, 130, 0.15);
        }

        #audio-group {
          background-color: rgba(100, 130, 180, 0.15);
        }
      '';
    };
  };
}
