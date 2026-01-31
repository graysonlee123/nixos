{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/common.nix
    ../../modules/devices/galaxy70.nix
    ../../modules/home-manager/gray.nix
  ];

  host.name = "nostromo";
  system.stateVersion = "25.11";
  greeter.unsupportedGpu = true;
}

