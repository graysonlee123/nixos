# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/host.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    curl
    inxi
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # GNOME keyring
  services.gnome.gnome-keyring.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Sway
  programs.sway.enable = true;

  # Zsh (required for it to be a valid login shell)
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the Docker daemon.
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # Required for Sway
  security.polkit.enable = true;

  # Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"sway --unsupported-gpu\"";
        user = "greeter";
      };
    };
  };

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

        # Keyboard
        input = {
          "type:keyboard" = {
            repeat_rate = "75";
            repeat_delay = "200";
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
        font-size = lib.mkDefault 14;
        theme = "Alien Blood";
        shell-integration-features = "ssh-env";
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
          modules-right = [ "cpu" "memory" "network" "pulseaudio" "clock" ];

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
    };

    # Notifications
    services.mako = {
      enable = true;
      defaultTimeout = 5000;  # 5 seconds
      backgroundColor = "#0a0e0a";
      textColor = "#00ff41";
      borderColor = "#00ff41";
      borderSize = 2;
      font = "JetBrainsMono Nerd Font 10";
    };

    # Chromium
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "dnebklifojaaecmheejjopgjdljebpeo"; } # everhour
      ];
    };

    # Required, should stay at the version originall installed
    home.stateVersion = "25.11";
  };
}
