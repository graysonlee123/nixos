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
          modules-right = lib.optional cfg.isLaptop "battery" ++ [ "cpu" "memory" "network" "pulseaudio" "clock" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };

          "sway/window" = {
            max-length = 50;
          };

          "cpu" = {
            format = " {usage}%";
            tooltip = false;
          };

          "memory" = {
            format = " {}%";
          };

          "network" = {
            format-wifi = " {essid}";
            format-ethernet = " {ipaddr}";
            format-disconnected = "⚠ Disconnected";
            tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          };

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-muted = " Muted";
            format-icons = {
              default = [ "" "" "" ];
            };
            on-click = "vicinae deeplink vicinae://extensions/rastsislaux/pulseaudio/pulseaudio";
          };

          "clock" = {
            format = " {:%H:%M}";
            format-alt = " {:%Y-%m-%d}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };

      style = ''
        * {
          font-family: JetBrainsMono Nerd Font;
          font-size: 13px;
        }

        window#waybar {
          background-color: #0a0e0a;
          color: #00ff41;
          border-bottom: 2px solid #00ff41;
        }

        #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #009900;
          border-bottom: 2px solid transparent;
        }

        #workspaces button:hover {
          background: rgba(0, 255, 65, 0.1);
          color: #00ff41;
        }

        #workspaces button.focused {
          background-color: rgba(0, 255, 65, 0.15);
          border-bottom: 2px solid #00ff41;
          color: #00ff41;
        }

        #workspaces button.urgent {
          background-color: #331100;
          border-bottom: 2px solid #ff6600;
          color: #ffaa00;
        }

        #mode {
          background-color: #001a00;
          border-bottom: 2px solid #00ff41;
          color: #00ff41;
        }

        #clock,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #window,
        #mode {
          padding: 0 10px;
          color: #00ff41;
        }

        #cpu {
          color: #00ff41;
        }

        #memory {
          color: #33ff33;
        }

        #network {
          color: #00cc33;
        }

        #network.disconnected {
          color: #ff6600;
        }

        #pulseaudio {
          color: #00dd33;
        }

        #pulseaudio.muted {
          color: #004400;
        }

        #clock {
          color: #00ff41;
        }
      '';
    };
  };
}
