{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/headed.nix
    ../../modules/nixos/fingerprint.nix
    ../../modules/nixos/auto-cpufreq.nix
    ../../users/gray.nix
  ];

  host.name = "corbelan";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;

  gray = {
    additionalPackages = with pkgs; [
      brightnessctl
    ];
  };
}
