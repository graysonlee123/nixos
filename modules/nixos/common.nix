{
  imports = [
    ./boot.nix
    ./networking.nix
    ./localization.nix
    ./user.nix
    ./system-packages.nix
    ./zsh.nix
    ./keyring.nix
    ./audio.nix
    ./greeter.nix
    ./openssh.nix
    ./steam.nix
    ./tailscale.nix
    ./docker.nix
    ./polkit.nix
    ./1password.nix
    ./stylix.nix
    ./clamav.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

