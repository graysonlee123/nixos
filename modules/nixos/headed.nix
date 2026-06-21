{
  imports = [
    ./1password.nix
    ./keyring.nix
    ./audio.nix
    ./greeter.nix
    ./steam.nix
    ./polkit.nix
    ./clamav.nix
    ./xdg.nix
    ./mullvad.nix
    ./bluetooth.nix
  ];

  programs.sway.enable = true;
}
