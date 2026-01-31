# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

let
  bookmarks = import ../../bookmarks.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/localization.nix
    ../../modules/nixos/user.nix
    ../../modules/nixos/system-packages.nix
    ../../modules/nixos/zsh.nix
    ../../modules/nixos/greeter.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/tailscale.nix
    inputs.home-manager.nixosModules.default
  ];

  host.name = "corbelan";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # GNOME keyring
  services.gnome.gnome-keyring.enable = true;

  # Enable the Docker daemon.
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Required for Sway
  security.polkit.enable = true;

  # Home Manager
  home-manager.users.gray = { config, lib, pkgs, ... }: {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Packages
    home.packages = with pkgs; [
      _1password-gui
      _2048-in-terminal
      asciiquarium
      bibata-cursors
      brightnessctl
      btop
      claude-code
      crawl
      discord
      dive
      docker
      dust
      filezilla
      ghostty
      git
      go
      jetbrains.phpstorm
      lazydocker
      lazygit
      mako
      mycli
      nerd-fonts.jetbrains-mono
      neofetch
      nethack
      nodejs_24
      obsidian
      pgadmin4
      pgcli
      pnpm
      ripgrep
      speedtest-cli
      tealdeer
      tuir
      unzip
      vscode
      wl-clipboard
      wp-cli
      yazi
      zip
    ];

    # Environment variables
    home.sessionVariables = {
      EDITOR = "vim";
    };

    # zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        "cl" = "claude";
        "lzd" = "lazydocker";
        "lzg" = "lazygit";
        "pn" = "pnpm";
        "y" = "yazi";
      };
    };

    # Starship prompt
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # fzf
    programs.fzf.enable = true;
    programs.fzf.enableZshIntegration = true;

    # Zoxide (smarter cd)
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # SSH
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
          identitiesOnly = true;
        };
        "inspry.github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github-inspry";
          identitiesOnly = true;
        };
        "154.12.120.83" = {
          identityFile = "~/.ssh/bigscoots";
          identitiesOnly = true;
        };
        "sulaco" = {
          hostname = "100.83.63.8";
          user = "grayson";
          identityFile = "~/.ssh/sulaco";
          identitiesOnly = true;
        };
        "sulaco.local" = {
          hostname = "192.168.86.2";
          user = "grayson";
          identityFile = "~/.ssh/sulaco";
          identitiesOnly = true;
        };
      };
    };

    # Git
    programs.git = {
      enable = true;
      includes = [
        {
          condition = "gitdir:~/repos/inspry/";
          contents = {
            user = {
              email = "grayson@inspry.com";
            };
          };
        }
      ];
      settings = {
        user.name = "Grayson Gantek";
        user.email = "github@graysn.com";
        pull.rebase = false;
        init.defaultBranch = "main";
      };
    };

    # Sway
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = let
        modifier = "Mod4";
      in {
        modifier = modifier;
        terminal = "ghostty";

        # Output configuration
        output = {
          "eDP-1" = {
            position = "0,540";  # 540 = 1440 - 900 (align to bottom)
            scale = "2";
          };
          "HDMI-A-1" = {
            position = "1440,0";
          };
        };

        # Lid switch - disable laptop display when lid is closed
        bindswitches = {
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
        
          # Flameshot
          "Print" = "exec flameshot gui";

          # Brightness
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

    # Cursor
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    home.pointerCursor.sway = {
      enable = true;
    };

    # Ghostty
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 10;
        theme = "rose-pine-moon";
        shell-integration-features = "ssh-env";
      };
      themes = {
        rose-pine-moon = {
          background = "191724";
          foreground = "e0def4";
          cursor-color = "e0def4";
          cursor-text = "191724";
          palette = [
            "0=#26233a"
            "1=#eb6f92"
            "2=#31748f"
            "3=#f6c177"
            "4=#9ccfd8"
            "5=#c4a7e7"
            "6=#ebbcba"
            "7=#e0def4"
            "8=#6e6a86"
            "9=#eb6f92"
            "10=#31748f"
            "11=#f6c177"
            "12=#9ccfd8"
            "13=#c4a7e7"
            "14=#ebbcba"
            "15=#e0def4"
          ];
          selection-background = "403d52";
          selection-foreground = "e0def4";
        };
      };
    };

    # Waybar
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
          modules-right = [ "battery" "cpu" "memory" "network" "pulseaudio" "clock" ];

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

    # Vicinae
    programs.vicinae = {
      enable = true;
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "pulseaudio";
          src =
            pkgs.fetchFromGitHub {
            owner = "vicinaehq";
              repo = "extensions";
              rev = "cc3326e7e07b4d2d0aa9ebc1a54ee3b0fb1db469";
              sha256 = "sha256-bDC2q3GlDjEE5J2SPHpIdbYKcuLDw3fsxSh3emMOEXU=";
            } + /extensions/pulseaudio;
        })
        (config.lib.vicinae.mkExtension {
          name = "nix";
          src =
            pkgs.fetchFromGitHub {
            owner = "vicinaehq";
              repo = "extensions";
              rev = "cc3326e7e07b4d2d0aa9ebc1a54ee3b0fb1db469";
              sha256 = "sha256-bDC2q3GlDjEE5J2SPHpIdbYKcuLDw3fsxSh3emMOEXU=";
            } + /extensions/nix;
        })
      ];
    };

    # Screenshots
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          showStartupLaunchMessage = false;
          savePath = "/home/gray/downloads";
        };
      };
    };

    # Notifications
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;  # 5 seconds
        background-color = "#0a0e0a";
        text-color = "#00ff41";
        border-color = "#00ff41";
        border-size = 2;
        font = "JetBrainsMono Nerd Font 10";
      };
    };

    # Chromium
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "dnebklifojaaecmheejjopgjdljebpeo"; } # everhour
      ];
    };

    # Declarative read-only bookmarks for both profiles
    xdg.configFile."chromium/Default/Bookmarks" = {
      text = bookmarks.mkChromiumBookmarks bookmarks.work;
      force = true; # Make read-only to enforce declarative management
    };

    xdg.configFile."chromium/Profile 1/Bookmarks" = {
      text = bookmarks.mkChromiumBookmarks bookmarks.personal;
      force = true; # Make read-only to enforce declarative management
    };

    # btop
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "rose-pine-moon";
      };
      themes = {
        rose-pine-moon = ''
          theme[main_bg]="#232136"
          theme[main_fg]="#e0def4"
          theme[title]="#908caa"
          theme[hi_fg]="#e0def4"
          theme[selected_bg]="#56526e"
          theme[selected_fg]="#f6c177"
          theme[inactive_fg]="#44415a"
          theme[graph_text]="#9ccfd8"
          theme[meter_bg]="#9ccfd8"
          theme[proc_misc]="#c4a7e7"
          theme[cpu_box]="#ea9a97"
          theme[mem_box]="#3e8fb0"
          theme[net_box]="#c4a7e7"
          theme[proc_box]="#eb6f92"
          theme[div_line]="#6e6a86"
          theme[temp_start]="#ea9a97"
          theme[temp_mid]="#f6c177"
          theme[temp_end]="#eb6f92"
          theme[cpu_start]="#f6c177"
          theme[cpu_mid]="#ea9a97"
          theme[cpu_end]="#eb6f92"
          theme[free_start]="#eb6f92"
          theme[free_mid]="#eb6f92"
          theme[free_end]="#eb6f92"
          theme[cached_start]="#c4a7e7"
          theme[cached_mid]="#c4a7e7"
          theme[cached_end]="#c4a7e7"
          theme[available_start]="#3e8fb0"
          theme[available_mid]="#3e8fb0"
          theme[available_end]="#3e8fb0"
          theme[used_start]="#ea9a97"
          theme[used_mid]="#ea9a97"
          theme[used_end]="#ea9a97"
          theme[download_start]="#3e8fb0"
          theme[download_mid]="#9ccfd8"
          theme[download_end]="#9ccfd8"
          theme[upload_start]="#ea9a97"
          theme[upload_mid]="#eb6f92"
          theme[upload_end]="#eb6f92"
          theme[process_start]="#3e8fb0"
          theme[process_mid]="#9ccfd8"
          theme[process_end]="#9ccfd8"
        '';
      };
    };

    # Required, should stay at the version originall installed
    home.stateVersion = "25.11";
  };
}
