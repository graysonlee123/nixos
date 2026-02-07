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
        ./discord.nix
        ./environment-variables.nix
        ./screenshots.nix
        ./fzf.nix
        ./ghostty.nix
        ./git.nix
        ./go.nix
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
        dive
        docker
        dust
        filezilla
        git-crypt
        grim
        jetbrains.phpstorm
        jq
        libnotify
        mycli
        nerd-fonts.jetbrains-mono
        neofetch
        nethack
        nodejs_24
        obsidian # TODO: Manage through home-manager?
        php82
        php82Packages.composer
        pgadmin4
        pnpm
        slurp
        speedtest-cli
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
