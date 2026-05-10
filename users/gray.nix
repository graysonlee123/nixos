{ pkgs, config, lib, inputs, ... }:

let
  cfg = config.gray;
  types = lib.types;
in {
  options.gray = {
    additionalPackages = lib.mkOption {
      type = types.listOf types.package;
      description = "Additional packages to add to the home manager configuration.";
      example = "[ brightnessctl ]";
      default = [];
    };

    isLaptop = lib.mkOption {
      type = types.bool;
      description = "If the host machine needs laptop configurations.";
      example = true;
      default = false;
    };
  };

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.users.gray = { config, lib, pkgs, ... }: {
      imports = [
        ../modules/home-manager/btop.nix
        ../modules/home-manager/chromium.nix
        ../modules/home-manager/cursor.nix
        ../modules/home-manager/environment-variables.nix
        ../modules/home-manager/screenshots.nix
        ../modules/home-manager/fzf.nix
        ../modules/home-manager/ghostty.nix
        ../modules/home-manager/git.nix
        ../modules/home-manager/go.nix
        ../modules/home-manager/iamb.nix
        ../modules/home-manager/mako.nix
        ../modules/home-manager/pgcli.nix
        ../modules/home-manager/ripgrep.nix
        ../modules/home-manager/ssh.nix
        ../modules/home-manager/starship.nix
        ../modules/home-manager/sway.nix
        ../modules/home-manager/tealdeer.nix
        ../modules/home-manager/vicinae.nix
        ../modules/home-manager/vim.nix
        ../modules/home-manager/vscode.nix
        ../modules/home-manager/waybar.nix
        ../modules/home-manager/yazi.nix
        ../modules/home-manager/zoxide.nix
        ../modules/home-manager/lazydocker.nix
        ../modules/home-manager/lazygit.nix
        ../modules/home-manager/zsh.nix
        ../modules/home-manager/claude-code.nix
        ../modules/home-manager/vesktop.nix
        ../modules/home-manager/xdg.nix
        ../modules/home-manager/imv.nix
        ../modules/home-manager/mullvad-waybar.nix
        ../modules/home-manager/nerd-dictation.nix
        ../modules/home-manager/radioboat.nix
        ../modules/home-manager/weather.nix
        ../modules/home-manager/batsignal.nix
      ];

      # Set laptop-specific options
      sway.isLaptop = cfg.isLaptop;
      waybar.isLaptop = cfg.isLaptop;
      batsignal.enable = cfg.isLaptop;

      # Fonts
      fonts.fontconfig.enable = true;

      # Packages
      home.packages = with pkgs; [
        _2048-in-terminal
        (atlauncher.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            wrapProgram $out/bin/atlauncher --set _JAVA_AWT_WM_NONREPARENTING 1
          '';
        }))
        alsa-utils
        asciiquarium
        bandwhich
        nload
        bat
        bibata-cursors
        crawl
        dig
        jdk25
        dive
        docker
        dust
        ffmpeg
        filezilla
        gh
        git-crypt
        grim
        heynote
        imagemagick
        jetbrains.phpstorm
        jq
        libnotify
        mullvad
        mycli
        nixfmt
        nerd-fonts.jetbrains-mono
        neofetch
        nethack
        nodejs_24
        obsidian # TODO: Manage through home-manager?
        postman
        prismlauncher
        pgadmin4-desktopmode
        (php82.withExtensions ({ enabled, all }: enabled ++ [ all.xdebug ]))
        php82Packages.composer
        pavucontrol
        playerctl
        pnpm
        pwgen
        python3
        qalculate-gtk
        radioboat
        r2modman
        rclone
        restic
        scc
        slurp
        speedtest-cli
        teamspeak6-client
        (pkgs.tidal-hifi.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/tidal-hifi --add-flags "--no-sandbox"
          '';
        }))
        trash-cli
        tree
        typescript-language-server
        tuir
        unzip
        vlc
        waylyrics
        wf-recorder
        wiremix
        wl-clipboard
        (wp-cli.override {
          php = php82;
          phpIniFile = pkgs.writeText "php.ini" (builtins.readFile "${php82}/etc/php.ini");
        })
        yt-dlp
        zip
      ] ++ cfg.additionalPackages;

      home.stateVersion = "25.11";
    };
  };
}
