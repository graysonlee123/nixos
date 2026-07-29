{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ../../modules/home/apps/chromium.nix
    ../../modules/home/apps/vesktop.nix
    ../../modules/home/cli/lftp.nix
    ../../modules/home/cli/radioboat.nix
    ../../modules/home/desktop/batsignal.nix
    ../../modules/home/desktop/cursor.nix
    ../../modules/home/desktop/ghostty.nix
    ../../modules/home/desktop/imv.nix
    ../../modules/home/desktop/mako.nix
    ../../modules/home/desktop/mullvad-waybar.nix
    ../../modules/home/desktop/screenshots.nix
    ../../modules/home/desktop/sway.nix
    ../../modules/home/desktop/vicinae.nix
    ../../modules/home/desktop/waybar.nix
    ../../modules/home/desktop/weather.nix
    ../../modules/home/dev/vscode.nix
    ../../modules/home/pim/calendar.nix
    ../../modules/home/pim/contacts.nix
    ../../modules/home/pim/khal.nix
    ../../modules/home/pim/khard.nix
    ../../modules/home/pim/vdirsyncer.nix
    ../../modules/home/system/syncthing.nix
    ../../modules/home/system/xdg.nix
  ];

  home.packages = with pkgs; [
    _2048-in-terminal
    alsa-utils
    asciiquarium
    bibata-cursors
    crawl
    filezilla
    grim
    jdk25
    jetbrains.phpstorm
    libnotify
    mullvad
    mycli
    nerd-fonts.jetbrains-mono
    nethack
    nodejs_24
    obsidian
    pavucontrol
    pgadmin4-desktopmode
    (php82.withExtensions ({ enabled, all }: enabled ++ [ all.xdebug ]))
    php82Packages.composer
    playerctl
    pnpm
    prismlauncher
    python3
    qalculate-gtk
    r2modman
    scc
    serie
    slurp
    teamspeak6-client
    (tidal-hifi.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/tidal-hifi --add-flags "--no-sandbox"
      '';
    }))
    typescript-language-server
    vlc
    waylyrics
    wf-recorder
    wiremix
    wl-clipboard
    (wp-cli.override {
      php = php82;
      phpIniFile = writeText "php.ini" (builtins.readFile "${php82}/etc/php.ini");
    })
  ];
}
