{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.waybar;
  mkDrawer =
    {
      orientation ? "horizontal",
      modules,
    }:
    {
      inherit modules orientation;
      drawer = {
        transition-duration = 300;
        transition-left-to-right = false;
        click-to-reveal = true;
      };
    };
  mkGhosttyCmd = cmd: "${pkgs.ghostty}/bin/ghostty -e ${cmd}";
in
{
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

          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "sway/window"
          ];
          modules-right = [
            "custom/dictation"
            "custom/music"
            "custom/weather"
            "custom/mullvad"
            "group/hw-group"
            "group/network-group"
            "group/audio-group"
            "group/clock-group"
          ];

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
              default = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              charging = [
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
            };
          };

          "cpu" = {
            format = "󰻠 {usage}%";
            tooltip = false;
          };

          "memory" = {
            format = "  {}%";
          };

          "group/hw-group" = {
            orientation = "horizontal";
            modules = [
              "group/hw-drawer"
              "cpu"
              "memory"
            ];
          };

          "group/hw-drawer" = {
            orientation = "horizontal";
            modules = [
              "custom/hw-btn"
              "temperature"
              "disk"
              "custom/btop-btn"
            ];
            drawer = {
              transition-duration = 300;
              transition-left-to-right = false;
              click-to-reveal = true;
            };
          };

          "custom/hw-btn" = {
            format = "󰅁";
            tooltip = false;
          };

          "temperature" = {
            format = "󰔏 {temperatureC}°C";
            tooltip = false;
          };

          "disk" = {
            format = "󰋊 {percentage_used}%";
            tooltip-format = "{used} / {total}";
          };

          "custom/btop-btn" = {
            format = "[btop]";
            tooltip = false;
            on-click = mkGhosttyCmd "${pkgs.btop}/bin/btop";
          };

          "group/network-group" = {
            orientation = "horizontal";
            modules = [
              "group/network-drawer"
              "network"
            ];
          };

          "group/network-drawer" = mkDrawer {
            modules = [
              "custom/network-btn"
              "network#bandwidth"
              "custom/bandwhich-btn"
              "custom/nload-btn"
              "custom/nmtui-btn"
            ];
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
            on-click = mkGhosttyCmd "${pkgs.bash}/bin/bash -c '/run/wrappers/bin/sudo ${pkgs.bandwhich}/bin/bandwhich'";
          };

          "custom/nload-btn" = {
            format = "[nload]";
            tooltip = false;
            on-click = mkGhosttyCmd "${pkgs.nload}/bin/nload";
          };

          "custom/nmtui-btn" = {
            format = "[nmtui]";
            tooltip = false;
            on-click = mkGhosttyCmd "/run/current-system/sw/bin/nmtui";
          };

          "group/audio-group" = {
            orientation = "horizontal";
            modules = [
              "group/audio-drawer"
              "wireplumber"
              "wireplumber#source"
            ];
          };

          "group/audio-drawer" = mkDrawer {
            modules = [
              "custom/audio-btn"
              "custom/alsamixer-btn"
              "custom/wiremix-btn"
              "custom/pavucontrol-btn"
            ];
          };

          "custom/audio-btn" = {
            format = "󰅁";
            tooltip = false;
          };

          "wireplumber" = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 [m]";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
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

          "custom/alsamixer-btn" = {
            format = "[alsamixer]";
            tooltip = false;
            on-click = mkGhosttyCmd "${pkgs.alsa-utils}/bin/alsamixer";
          };

          "custom/wiremix-btn" = {
            format = "[wiremix]";
            tooltip = false;
            on-click = mkGhosttyCmd "${pkgs.wiremix}/bin/wiremix";
          };

          "custom/pavucontrol-btn" = {
            format = "[pavucontrol]";
            tooltip = false;
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          "group/clock-group" = {
            orientation = "horizontal";
            modules = [ "group/clock-drawer" ] ++ lib.optional cfg.isLaptop "battery" ++ [ "clock" ];
          };

          "group/clock-drawer" = mkDrawer {
            modules = [
              "custom/clock-btn"
              "custom/uptime"
              "clock#utc-offset"
            ];
          };

          "custom/clock-btn" = {
            format = "󰅁";
            tooltip = false;
          };

          "clock" = {
            format = "󰃭 {0:%m/%d} {0:%I:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "clock#utc-offset" = {
            format = "UTC{:%z}";
            tooltip = false;
          };

          "custom/uptime" = {
            exec = "${pkgs.gawk}/bin/awk '{s=$1; d=int(s/86400); h=int((s%86400)/3600); m=int((s%3600)/60); if(d>0) printf \"%dd %dh\", d, h; else printf \"%dh %dm\", h, m}' /proc/uptime";
            interval = 60;
            format = "󰅐 {}";
            tooltip = false;
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

        #custom-dictation,
        #custom-weather,
        #custom-music,
        #window,
        #mode {
          padding: 0 10px;
        }

        #clock,
        #cpu,
        #memory,
        #temperature,
        #network,
        #disk,
        #wireplumber,
        #custom-hw-btn,
        #custom-network-btn,
        #custom-audio-btn,
        #custom-btop-btn,
        #custom-bandwhich-btn,
        #custom-nload-btn,
        #custom-nmtui-btn,
        #custom-wiremix-btn,
        #custom-pavucontrol-btn,
        #custom-alsamixer-btn,
        #custom-clock-btn,
        #custom-uptime,
        #battery {
          padding: 0 5px;
        }

        /* Waybar sets STATE_FLAG_PRELIGHT (mapped to :hover in GTK CSS) on the
           group box when the drawer is open — there is no .open class. */
        #hw-drawer,
        #network-drawer,
        #audio-drawer,
        #clock-drawer {
          border-radius: 4px;
        }

        #hw-drawer:hover,
        #network-drawer:hover,
        #audio-drawer:hover,
        #clock-drawer:hover {
          background-color: rgba(255, 255, 255, 0.05);
        }

        #hw-group,
        #network-group,
        #audio-group,
        #clock-group {
          border-radius: 4px;
          padding: 4px;
          margin: 3px 2px;
        }

        #hw-group {
          background-color: rgba(180, 140, 100, 0.15);
        }

        #network-group {
          background-color: rgba(100, 180, 130, 0.15);
        }

        #audio-group {
          background-color: rgba(100, 130, 180, 0.15);
        }

        #clock-group {
          background-color: rgba(160, 100, 180, 0.15);
        }
      '';
    };
  };
}
