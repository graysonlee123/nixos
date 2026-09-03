{pkgs, ...}: {
  imports = [
    ../modules/nixos/core/boot.nix
    ../modules/nixos/core/docker.nix
    ../modules/nixos/core/journald.nix
    ../modules/nixos/core/localization.nix
    ../modules/nixos/core/sudo.nix
    ../modules/nixos/core/user.nix
    ../modules/nixos/core/zsh.nix
    ../modules/nixos/network/networking.nix
    ../modules/nixos/network/openssh.nix
    ../modules/nixos/network/tailscale.nix
    ../modules/nixos/system/gcp.nix
    ../modules/nixos/system/sops.nix
    ../modules/nixos/theme/stylix.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    curl
    file
    inxi
    mangohud
    openvpn
    age
    sops
  ];
}
