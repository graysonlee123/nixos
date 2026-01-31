{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/home-manager/gray.nix
  ];

  # TODO: restore laptop-specific Sway configuration

  host.name = "corbelan";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;
}

