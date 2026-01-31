{
  imports = [
    ./boot.nix
    ./networking.nix
    ./localization.nix
    ./user.nix
    ./system-packages.nix
    ./zsh.nix
    ./keyring.nix
    ./greeter.nix
    ./openssh.nix
    ./tailscale.nix
    ./docker.nix
    ./polkit.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

