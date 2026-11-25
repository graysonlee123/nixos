{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/headed.nix
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/hardware/galaxy70.nix
    ../../modules/nixos/hardware/samson-q9u-gain.nix
    ../../users/gray.nix
  ];

  host.name = "nostromo";
  host.formFactor.type = "desktop";
  system.stateVersion = "25.11";
  networking.networkmanager.enable = true;

  # Primary display
  displays.primary = {
    id = "DP-1";
    label = "LG UltraGear 32GS75QX-B.AUS 32\"";
    resolution.x = 2560;
    resolution.y = 1440;
    refreshRate = "180.063";
    variableRefreshRate = true; # Always-on VRR: many games' gamescope windows have no app-id, so on-demand window rules can't match them reliably.
    focusAtStartup = true;
  };

  # Secondary display
  displays.secondary = {
    id = "HDMI-A-1";
    label = "ASUS ROG Strix XG129C 12.3\"";
    resolution.x = 1920;
    resolution.y = 720;
    refreshRate = "75.000";
    position.x = 496; # Centered under DP-1: (2560 - 1536) / 2 = 512, minus 16 to nudge left.
    position.y = 1440;
    scale = 1.25; # Pinned: position.x centering assumes logical width 1920 / 1.25 = 1536.
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/983d9ad7-1cbc-490d-8bd4-c10704a634f4";
    fsType = "ext4";
    options = ["noatime"];
  };
}
