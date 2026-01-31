{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ./home.nix
  ];

  host.name = "corbelan";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;
}

