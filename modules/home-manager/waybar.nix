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
          modules-right = [ "custom/dictation" "custom/music" "custom/weather" "cpu" "memory" "custom/mullvad" "group/network-group" "wireplumber" "wireplumber#source" ] ++ lib.optional cfg.isLaptop "battery" ++ [ "clock" ];

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
            modules = [ "network" "network#bandwidth" "custom/bandwhich-btn" "custom/nload-btn" "custom/nmtui-btn" ];
            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
              click-to-reveal = true;
            };
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

        #custom-bandwhich-btn,
        #custom-nload-btn,
        #custom-nmtui-btn {
          padding: 0 5px;
        }

        /* Waybar sets STATE_FLAG_PRELIGHT (mapped to :hover in GTK CSS) on the
           group box when the drawer is open — there is no .open class. */
        #network-group:hover {
          background-color: rgba(255, 255, 255, 0.05);
        }
      '';
    };
  };
}
