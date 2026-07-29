{
  imports = [
    ./base.nix
    ../modules/nixos/core/greeter.nix
    ../modules/nixos/core/polkit.nix
    ../modules/nixos/core/xdg.nix
    ../modules/nixos/desktop/sway.nix
    ../modules/nixos/gaming/gamemode.nix
    ../modules/nixos/gaming/steam.nix
    ../modules/nixos/hardware/audio.nix
    ../modules/nixos/hardware/bluetooth.nix
    ../modules/nixos/network/mullvad.nix
    ../modules/nixos/security/1password.nix
    ../modules/nixos/security/clamav.nix
    ../modules/nixos/security/keyring.nix
  ];
}
