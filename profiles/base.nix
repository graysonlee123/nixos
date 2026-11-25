{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../modules/nixos/core/boot.nix
    ../modules/nixos/core/form-factor.nix
    ../modules/nixos/core/docker.nix
    ../modules/nixos/core/domains.nix
    ../modules/nixos/core/emails.nix
    ../modules/nixos/core/home-manager.nix
    ../modules/nixos/core/journald.nix
    ../modules/nixos/core/lan.nix
    ../modules/nixos/core/localization.nix
    ../modules/nixos/core/sudo.nix
    ../modules/nixos/core/user.nix
    ../modules/nixos/core/zsh.nix
    ../modules/nixos/hardware/fwupd.nix
    ../modules/nixos/network/networking.nix
    ../modules/nixos/network/openssh.nix
    ../modules/nixos/network/tailscale.nix
    ../modules/nixos/system/gcp.nix
    ../modules/nixos/system/pgadmin-overlay.nix
    ../modules/nixos/system/sops.nix
    ../modules/nixos/theme/stylix.nix
  ];

  nixpkgs = {
    # Colmena skips lib.nixosSystem, which normally sets this. Points
    # NIX_PATH + registry `nixpkgs` at the pinned input (comma needs it).
    flake.source = inputs.nixpkgs;
    config.allowUnfree = true;
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
    curl
    file
    gdb
    gcc
    inxi
    openvpn
    age
    sops
    nvd
  ];
}
