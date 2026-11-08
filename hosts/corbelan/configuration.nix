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

  # Standalone iwd (no NetworkManager): Impala talks to iwd directly; NM's iwd
  # backend was forgetting iwd known networks on failed connects.
  networking.wireless.enable = false; # disable wpa_supplicant
  networking.dhcpcd.denyInterfaces = ["wlan0" "docker*" "br-*" "veth*"]; # iwd handles wlan0
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true; # iwd built-in DHCP
      };
      Network = {
        EnableIPv6 = false; # case-sensitive
        NameResolvingService = "resolvconf";
      };
    };
  };
}
