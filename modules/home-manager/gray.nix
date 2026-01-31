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
        ./mako.nix
        ./ssh.nix
        ./starship.nix
        ./sway.nix
        ./vicinae.nix
        ./waybar.nix
        ./zoxide.nix
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
        _1password-gui
        _2048-in-terminal
        asciiquarium
        bibata-cursors
        btop
        crawl
        discord
        dive
        docker
        dust
        filezilla
        ghostty
        git
        go
        grim
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
        slurp
        speedtest-cli
        tealdeer
        tuir
        unzip
        vlc
        vscode
        wl-clipboard
        wp-cli
        yazi
        zip
      ] ++ cfg.additionalPackages;

      home.stateVersion = "25.11";
    };
  };
}
