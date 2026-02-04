{ config, lib, ... }:

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

          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = lib.optional cfg.isLaptop "battery" ++ [ "cpu" "memory" "network" "wireplumber" "clock" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };

          "sway/window" = {
            max-length = 50;
          };

          "cpu" = {
            format = "󰻠 {usage}%";
            tooltip = false;
          };

          "memory" = {
            format = " {}%";
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
            on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
            on-click-right = "/home/gray/.nix-profile/bin/ghostty -e /home/gray/.nix-profile/bin/wiremix";
          };

          "clock" = {
            format = "󰃭 {0:%I:%M} {0:%m/%d}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
        #window,
        #mode {
          padding: 0 10px;
        }
      '';
    };
  };
}
