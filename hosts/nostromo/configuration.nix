{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/common.nix
    ../../modules/devices/galaxy70.nix
    ./home.nix
  ];

  host.name = "nostromo";
  system.stateVersion = "25.11";
  greeter.unsupportedGpu = true;

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/983d9ad7-1cbc-490d-8bd4-c10704a634f4";
    fsType = "ext4";
    options = [ "noatime" ];
  };
}

