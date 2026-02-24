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
        bibata-cursors
        crawl
        dig
        dive
        docker
        dust
        filezilla
        git-crypt
        grim
        heynote
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
        pgadmin4-desktopmode
        php82
        php82Packages.composer
        pnpm
        qalculate-gtk
        r2modman
        rclone
        restic
        slurp
        speedtest-cli
        teamspeak6-client
        tree
        tuir
        unzip
        vlc
        wf-recorder
        wiremix
        wl-clipboard
        (wp-cli.override {
          php = php82;
          phpIniFile = pkgs.writeText "php.ini" (builtins.readFile "${php82}/etc/php.ini");
        })
        zip
      ] ++ cfg.additionalPackages;

      home.stateVersion = "25.11";
    };
  };
}
