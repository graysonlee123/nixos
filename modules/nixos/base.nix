{
  imports = [
    ./boot.nix
    ./networking.nix
    ./localization.nix
    ./user.nix
    ./system-packages.nix
    ./zsh.nix
    ./openssh.nix
    ./tailscale.nix
    ./docker.nix
    ./stylix.nix
    ./sudo.nix
    ./journald.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
