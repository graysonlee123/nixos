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
  constants = import ../data/constants.nix;
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
    ../modules/home-manager/sops.nix
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

        keys.ssh =
          let
            email = constants.emails.personal;
            inspryEmail = constants.emails.work;
            sulacoPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUikXnlXo9JwzeSMwdH4PCw/dgKnDYbIgSJxjXSEzMX ${email}";
          in
          {
            # Personal
            "github.com" = {
              enable = true;
              sopsFile = "shared.yaml";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMvd+/flMOPe9Ei/FqGC5I73tQSTGq3sh5hD3ymxGn4 ${email}";
              user = "git";
            };
            "sulaco" = {
              enable = !isHeadless;
              sopsFile = "shared.yaml";
              hostName = constants.hosts.sulaco.ips.tailscale;
              publicKey = sulacoPublicKey;
              privateKeyName = "sulaco";
              user = config.users.users.gray.name;
            };
            "sulaco.local" = {
              enable = !isHeadless;
              sopsFile = "shared.yaml";
              hostName = constants.hosts.sulaco.ips.lan;
              publicKey = sulacoPublicKey;
              privateKeyName = "sulaco";
              user = config.users.users.gray.name;
            };

            # Inspry
            "*.pressable.com" = {
              enable = !isHeadless;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrAiQZ99gkpglncP8N/zg3y9I8aTfvl4VGaZWWAAuMK ${inspryEmail}";
            };
            "*.ssh.wpengine.net" = {
              enable = !isHeadless;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9ZyskpBlKwO3lKiiOrj9q8zpS9pkKoOyCiybsVK3Sf ${inspryEmail}";
            };
            "bigscoots" = {
              enable = !isHeadless;
              hostName = "154.12.120.83";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXWYAv1t8J/NJsXrGlnuD2wtY5B/B18rwDgy5ZZzsHp ${inspryEmail}";
              user = "nginx";
              port = 2222;
            };
            "bitbucket.org" = {
              enable = !isHeadless;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4XIeCOgGQrV7OitP5mMimJSI/bHZDmF/RMmazljroL ${inspryEmail}";
              user = "git";
            };
            "inspry.github.com" = {
              enable = !isHeadless;
              hostName = "github.com";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuKD0o+ZwnwxkYAg/niixNMzZPeyTDOa84ALYoMA2uQ ${inspryEmail}";
              user = "git";
            };
            "rocket.net" = {
              enable = !isHeadless;
              hostName = "131.153.238.180";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbB3KDWI1xOUJFknHkQfKrtXV42RqdCTpG86DawlxyO ${inspryEmail}";
            };
            "ssh.dev.azure.com" = {
              enable = !isHeadless;
              publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6B/D+V7277HHCohcRLhz+QOiMPbOZaaU/mii9hZSEmA3aTWRWuu+v3bLjCRSRFKAUBVWxEnomIcGVmEnLMMjOlnfyEFGxCeJzlkuyV/erKU+RCUE8BqRaixF6ZJuMKb6kELcuNhnXSzl28lN6taTvFvPR47Y/wwcOHYHZwHmUyj1tvbfXL/Z/06lxEJ82UWK25LktJGHuLHIvOSpJ+3U74nPmBwNRPkULOMNUD/uK+Sn35nQjQm6zHZDmleN9XzxfX1+vepIcvJ7DCU8KChyUgeczyQvWWmH0rTZlHVHKRC/YNMdk8Zm/a5k7koFmMPIZp69iJ+QezL0GAZL3U4QWx/9U3ifJNpnthHH0LsYXrk532staHfKivyLSqIf34xVUiOj5WJQrEGAODVQkdbivoosB1IZP7nm4r+hsqenVk1u0BJfGxaNAHEiItHJXaXMfsYdSocMcL0F7k8rI/GcWIXSoCvLjYHhj21Ya/tbBK7QmpPTB25melMAybpt9Rs8= ${inspryEmail}";
            };
            "usartframes.com" = {
              enable = !isHeadless;
              hostName = "72.167.87.201";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMdLQjQVk1WVTjynhGc60zRHFbJacAqFI5A274IdxKf ${inspryEmail}";
              user = "p59furxwzjsc";
            };
          };
      };
  };
}
