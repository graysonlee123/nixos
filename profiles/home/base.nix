{ pkgs, isHeadless, ... }:

{
  imports = [
    ../../modules/home/cli/btop.nix
    ../../modules/home/cli/fzf.nix
    ../../modules/home/cli/lazydocker.nix
    ../../modules/home/cli/lazygit.nix
    ../../modules/home/cli/pgcli.nix
    ../../modules/home/cli/ripgrep.nix
    ../../modules/home/cli/starship.nix
    ../../modules/home/cli/tealdeer.nix
    ../../modules/home/cli/vim.nix
    ../../modules/home/cli/yazi.nix
    ../../modules/home/cli/zoxide.nix
    ../../modules/home/cli/zsh.nix
    ../../modules/home/dev/claude-code.nix
    ../../modules/home/dev/git.nix
    ../../modules/home/dev/go.nix
    ../../modules/home/system/environment-variables.nix
    ../../modules/home/system/sops.nix
    ../../modules/home/system/ssh.nix
  ];

  home.stateVersion = "25.11";
  fonts.fontconfig.enable = !isHeadless;

  home.packages = with pkgs; [
    bandwhich
    bat
    dig
    dive
    docker
    dust
    ffmpeg
    gh
    git-crypt
    glow
    httpie-desktop
    imagemagick
    jq
    nixd
    nixfmt
    nload
    pwgen
    rclone
    restic
    speedtest-cli
    trash-cli
    tree
    trufflehog
    unzip
    yt-dlp
    zip
  ];
}
