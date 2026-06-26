{
  config,
  lib,
  pkgs,
  isHeadless,
  ...
}:

let
  cfg = config.gray;
  types = lib.types;
  hmBaseImports = [
    ../modules/home-manager/btop.nix
    ../modules/home-manager/claude-code.nix
    ../modules/home-manager/environment-variables.nix
    ../modules/home-manager/fzf.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/go.nix
    ../modules/home-manager/lazydocker.nix
    ../modules/home-manager/lazygit.nix
    ../modules/home-manager/pgcli.nix
    ../modules/home-manager/ripgrep.nix
    ../modules/home-manager/ssh.nix
    ../modules/home-manager/starship.nix
    ../modules/home-manager/syncthing.nix
    ../modules/home-manager/tealdeer.nix
    ../modules/home-manager/vim.nix
    ../modules/home-manager/yazi.nix
    ../modules/home-manager/zoxide.nix
    ../modules/home-manager/zsh.nix
  ];
  hmHeadlessImports = [ ];
  hmHeadedImports = [
    ../modules/home-manager/batsignal.nix
    ../modules/home-manager/chromium.nix
    ../modules/home-manager/cursor.nix
    ../modules/home-manager/ghostty.nix
    ../modules/home-manager/iamb.nix
    ../modules/home-manager/imv.nix
    ../modules/home-manager/mako.nix
    ../modules/home-manager/mullvad-waybar.nix
    ../modules/home-manager/nerd-dictation.nix
    ../modules/home-manager/radioboat.nix
    ../modules/home-manager/screenshots.nix
    ../modules/home-manager/sway.nix
    ../modules/home-manager/vesktop.nix
    ../modules/home-manager/vicinae.nix
    ../modules/home-manager/vscode.nix
    ../modules/home-manager/waybar.nix
    ../modules/home-manager/weather.nix
    ../modules/home-manager/xdg.nix
  ];
  hmImports = hmBaseImports ++ (if isHeadless then hmHeadlessImports else hmHeadedImports);
  basePackages = with pkgs; [
    bandwhich
    nload
    bat
    dig
    dive
    docker
    dust
    ffmpeg
    gh
    git-crypt
    imagemagick
    jq
    nixfmt
    neofetch
    nixd
    pwgen
    rclone
    restic
    speedtest-cli
    trash-cli
    tree
    trufflehog
    tuir
    unzip
    yt-dlp
    zip
  ];
  headlessPackages = with pkgs; [ ];
  headedPackages = with pkgs; [
    _2048-in-terminal
    (atlauncher.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        wrapProgram $out/bin/atlauncher --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    }))
    alsa-utils
    asciiquarium
    bibata-cursors
    crawl
    jdk25
    filezilla
    grim
    heynote
    jetbrains.phpstorm
    lftp
    libnotify
    mullvad
    mycli
    nerd-fonts.jetbrains-mono
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
    python3
    qalculate-gtk
    radioboat
    r2modman
    scc
    slurp
    teamspeak6-client
    (tidal-hifi.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/tidal-hifi --add-flags "--no-sandbox"
      '';
    }))
    typescript-language-server
    vlc
    wf-recorder
    waylyrics
    wl-clipboard
    wiremix
    (wp-cli.override {
      php = php82;
      phpIniFile = writeText "php.ini" (builtins.readFile "${php82}/etc/php.ini");
    })
  ];
  packages = basePackages ++ (if isHeadless then headlessPackages else headedPackages);
in
{
  options.gray = {
    additionalPackages = lib.mkOption {
      type = types.listOf types.package;
      description = "Additional packages to add to the home manager configuration.";
      example = "[ brightnessctl ]";
      default = [ ];
    };

  };

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.users.gray =
      {
        ...
      }:
      {
        imports = hmImports;
        home.packages = packages ++ cfg.additionalPackages;
        fonts.fontconfig.enable = !isHeadless;
        home.stateVersion = "25.11";
      };
  };
}
