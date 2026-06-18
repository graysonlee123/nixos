{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/fingerprint.nix
    ../../modules/nixos/auto-cpufreq.nix
    ../../users/gray.nix
  ];

  host.name = "corbelan";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;

  gray = {
    isLaptop = true;
    additionalPackages = with pkgs; [
      brightnessctl
    ];
  };
}
