{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/headed.nix
    ../../modules/nixos/hardware/fingerprint.nix
    ../../modules/nixos/hardware/auto-cpufreq.nix
    ../../users/gray.nix
  ];

  host.name = "corbelan";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;

  gray = {
    additionalPackages = with pkgs; [
      brightnessctl
      impala
    ];
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.enable = false; # disable wpa_supplicant
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network = {
        EnableIPV6 = false;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };
}
