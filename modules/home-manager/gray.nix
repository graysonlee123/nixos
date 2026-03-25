{ pkgs, config, lib, inputs, ... }:

let
  cfg = config.home;
  types = lib.types;
in {
  options.home = {
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
        ./btop.nix
        ./chromium.nix
        ./cursor.nix
        ./environment-variables.nix
        ./screenshots.nix
        ./fzf.nix
        ./ghostty.nix
        ./git.nix
        ./go.nix
        ./iamb.nix
        ./mako.nix
        ./pgcli.nix
        ./ripgrep.nix
        ./ssh.nix
        ./starship.nix
        ./sway.nix
        ./tealdeer.nix
        ./vicinae.nix
        ./vim.nix
        ./vscode.nix
        ./waybar.nix
        ./yazi.nix
        ./zoxide.nix
        ./lazydocker.nix
        ./lazygit.nix
        ./zsh.nix
        ./claude-code.nix
        ./vesktop.nix
        ./xdg.nix
        ./imv.nix
        ./nerd-dictation.nix
        ./radioboat.nix
        ./weather.nix
      ];

      # Set laptop-specific options
      sway.isLaptop = cfg.isLaptop;
      waybar.isLaptop = cfg.isLaptop;

      # Fonts
      fonts.fontconfig.enable = true;

      # Packages
      home.packages = with pkgs; [
        _2048-in-terminal
        asciiquarium
        bat
        bibata-cursors
        crawl
        dig
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
        mycli
        nixfmt
        nerd-fonts.jetbrains-mono
        neofetch
        nethack
        nodejs_24
        obsidian # TODO: Manage through home-manager?
        postman
        pgadmin4-desktopmode
        php82
        php82Packages.composer
        playerctl
        pnpm
        pwgen
        python3
        qalculate-gtk
        radioboat
        r2modman
        rclone
        restic
        slurp
        speedtest-cli
        teamspeak6-client
        (pkgs.tidal-hifi.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/tidal-hifi --add-flags "--no-sandbox"
          '';
        }))
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
