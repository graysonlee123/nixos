{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/headed.nix
    ../../modules/nixos/hardware/fingerprint.nix
    ../../modules/nixos/hardware/auto-cpufreq.nix
    ../../users/gray.nix
  ];

  host.name = "corbelan";
  host.formFactor.type = "laptop";
  system.stateVersion = "25.11";
  hardware.graphics.enable = true;

  # Primary display
  displays.primary = {
    id = "HDMI-A-1";
    label = "LG UltraGear 2k";
    resolution.x = 2560;
    resolution.y = 1440;
    refreshRate = "59.951";
    position.x = 1646;
    position.y = -411;
    focusAtStartup = true;
  };

  # Secondary display
  displays.secondary = {
    id = "eDP-1";
    label = "Monitor display";
    resolution.x = 2880;
    resolution.y = 1800;
    refreshRate = "120.00";
    variableRefreshRate = true; # Always-on VRR: OLED drops refresh when idle, saves battery.
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
