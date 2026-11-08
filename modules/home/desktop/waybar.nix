{
  isLaptop,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  isNostromo = osConfig.networking.hostName == "nostromo";
  mkDrawer = {
    orientation ? "horizontal",
    modules,
  }: {
    inherit modules orientation;
    drawer = {
      transition-duration = 300;
      transition-left-to-right = false;
      click-to-reveal = true;
    };
  };
  # +new-window: open in the resident ghostty instance (instant).
  mkGhosttyCmd = cmd: "${pkgs.ghostty}/bin/ghostty +new-window -e ${cmd}";
in {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = ["graphical-session.target"];
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        fixed-center = false;

        # https://github.com/Alexays/Waybar/wiki/Module:-Niri
        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];

        modules-right = [
          "custom/mullvad"
          "custom/music"
          "custom/weather"
          "group/tray-group"
          "group/hw-group"
          "group/network-group"
          "group/audio-group"
          "group/clock-group"
        ];

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

        # TUIs open on click (no drawer buttons).
        "cpu" = {
          format = "󰻠 {usage}%";
          tooltip = false;
          on-click = mkGhosttyCmd "${pkgs.btop}/bin/btop";
        };

        "memory" = {
          format = "  {}%";
          on-click = mkGhosttyCmd "${pkgs.btop}/bin/btop";
        };

        "tray" = {
          icon-size = 16;
          spacing = 8;
        };

        # gsr status isn't a real tray item (no StatusNotifierItem), so group
        # it with the tray to sit alongside the app icons.
        "group/tray-group" = {
          orientation = "horizontal";
          modules = [
            "custom/gsr"
            "tray"
          ];
        };

        "group/hw-group" = {
          orientation = "horizontal";
          modules = [
            "group/hw-drawer"
            "cpu"
            "memory"
          ];
        };

        "group/hw-drawer" = mkDrawer {
          modules = [
            "custom/hw-btn"
            "temperature"
            "disk"
          ];
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
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\nClick: ${
            if isLaptop
            then "impala"
            else "nmtui"
          } | Right: nload | Middle: bandwhich";
          on-click =
            if isLaptop
            then mkGhosttyCmd "${pkgs.impala}/bin/impala"
            else mkGhosttyCmd "/run/current-system/sw/bin/nmtui";
          on-click-right = mkGhosttyCmd "${pkgs.nload}/bin/nload";
          on-click-middle = mkGhosttyCmd "${pkgs.bash}/bin/bash -c '/run/wrappers/bin/sudo ${pkgs.bandwhich}/bin/bandwhich'";
        };

        "network#bandwidth" = {
          format-wifi = "↓{bandwidthDownBytes} ↑{bandwidthUpBytes}";
          format-ethernet = "↓{bandwidthDownBytes} ↑{bandwidthUpBytes}";
          format-disconnected = "";
          tooltip = false;
          interval = 2;
          on-click = mkGhosttyCmd "${pkgs.nload}/bin/nload";
        };

        "group/audio-group" = {
          orientation = "horizontal";
          modules =
            [
              "wireplumber"
              "wireplumber#source"
            ]
            ++ lib.optional isNostromo "custom/mic-gain";
        };

        # Samson Q9U hardware "Mic Gain" (ALSA), distinct from PipeWire input
        # volume above. Report the dB gain (what alsamixer's header shows); it
        # is linear in the raw value and avoids the percent-curve mismatch.
        # Keep exec a single line — a multiline exec makes waybar treat it as a
        # continuous script and ignore `interval`. Emit a trailing newline
        # (awk `print`) or waybar never commits the updated value.
        "custom/mic-gain" = {
          exec = "${pkgs.alsa-utils}/bin/amixer -c Q9U sget 'Mic Gain' | ${pkgs.gawk}/bin/awk -F'[][]' '/Mono:.*Capture/{gsub(\"dB\",\"\",$4); print int($4)}'";
          interval = 5;
          format = "󰢻 {}dB";
          tooltip-format = "Samson Q9U mic gain";
          on-click = mkGhosttyCmd "${pkgs.alsa-utils}/bin/alsamixer";
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
          tooltip-format = "{node_name}\nClick: mute | Right: wiremix | Middle: pavucontrol";
          on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = mkGhosttyCmd "${pkgs.wiremix}/bin/wiremix";
          on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "wireplumber#source" = {
          node-type = "Audio/Source";
          format = "󰍬 {volume}%";
          format-muted = "󰍭 [m]";
          scroll-step = 5;
          tooltip-format = "{node_name}\nClick: mute | Right: wiremix | Middle: alsamixer";
          on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle";
          on-click-right = mkGhosttyCmd "${pkgs.wiremix}/bin/wiremix";
          on-click-middle = mkGhosttyCmd "${pkgs.alsa-utils}/bin/alsamixer";
        };

        "group/clock-group" = {
          orientation = "horizontal";
          modules = ["group/clock-drawer"] ++ lib.optional isLaptop "battery" ++ ["clock"];
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
          max-length =
            if isLaptop
            then 32
            else 64;
          escape = true;
          # --follow: playerctl prints on every change (no polling). Empty line
          # when no player, hidden by hide-empty-text.
          exec = "${pkgs.playerctl}/bin/playerctl --follow metadata --format '  {{title}} - {{artist}}'";
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          on-click-right = "${pkgs.playerctl}/bin/playerctl next";
          on-click-middle = "${pkgs.playerctl}/bin/playerctl previous";
          tooltip = true;
          tooltip-format = "{}\nClick: play/pause | Right: next | Middle: previous";
        };
      };
    };

    style = ''
      /* Pills instead of Stylix's underline. Extra specificity beats its
         .modules-left #workspaces button rules. */
      window#waybar .modules-left #workspaces button {
        padding: 0 8px;
        margin: 3px 2px 5px;
        border-radius: 6px;
        border-bottom: none;
      }

      window#waybar .modules-left #workspaces button:hover {
        background: alpha(@base05, 0.1);
        box-shadow: none;
        text-shadow: none;
      }

      window#waybar .modules-left #workspaces button.active {
        background-color: alpha(@base0D, 0.35);
        color: @base07;
      }

      window#waybar .modules-left #workspaces button.urgent {
        background-color: alpha(@base08, 0.6);
        color: @base07;
      }

      window#waybar .modules-left #workspaces {
        margin-left: 3px;
      }

      #window,
      #submap {
        padding: 0 10px;
      }

      /* Standalone right-side modules share one box so spacing matches the
         group pills; hidden (empty) modules take no space. */
      #custom-music,
      #custom-weather,
      #custom-mullvad,
      #tray-group {
        padding: 0 8px;
        margin: 3px 2px 5px;
        border-radius: 4px;
      }

      /* Inside tray-group: gsr spaced like a tray icon (tray spacing 8). */
      #custom-gsr {
        padding: 0 4px;
        margin-right: 4px;
        border-radius: 4px;
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
      #custom-mic-gain,
      #custom-clock-btn,
      #custom-uptime,
      #battery {
        padding: 0 5px;
      }

      /* Waybar sets STATE_FLAG_PRELIGHT (mapped to :hover in GTK CSS) on the
         group box when the drawer is open — there is no .open class. */
      #hw-drawer,
      #network-drawer,
      #clock-drawer {
        border-radius: 4px;
      }

      #hw-drawer:hover,
      #network-drawer:hover,
      #clock-drawer:hover {
        background-color: alpha(@base05, 0.05);
      }

      #hw-group,
      #network-group,
      #audio-group,
      #clock-group {
        border-radius: 4px;
        padding: 4px;
        margin: 3px 2px 5px;
      }

      #hw-group {
        background-color: alpha(@base09, 0.15);
      }

      #network-group {
        background-color: alpha(@base0B, 0.15);
      }

      #audio-group {
        background-color: alpha(@base0D, 0.15);
      }

      #clock-group {
        background-color: alpha(@base0E, 0.15);
        margin-right: 3px;
      }
    '';
  };
}
