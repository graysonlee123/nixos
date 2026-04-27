# Host-Specific Configurations

## Corbelan (Laptop)

- **CPU**: AMD
- **Graphics**: Integrated AMD (Radeon)
- **Brightness Control**: brightnessctl package for managing screen brightness
- **Font Size**: Smaller font size for teeny Hi-DPI laptop display
- **Fingerprint Reader**: Enabled via fprintd (`modules/nixos/fingerprint.nix`). Works for sudo, TTY login, and the ly greeter.

**Fingerprint enrollment** (first-time setup or re-enrollment):
```bash
sudo fprintd-enroll $USER
```

**Verify enrollment:**
```bash
sudo fprintd-verify $USER
```

## Nostromo (Desktop)

- **CPU**: Intel
- **Graphics**: NVIDIA with open-source drivers
- **GPU Configuration**:
  - `hardware.nvidia.open = true`
  - `hardware.nvidia.modesetting.enable = true`
- **Chromium green screen on videos**: Disable `chrome://flags/#disable-accelerated-video-decode` (set to Disabled). NVIDIA + Wayland hardware video decode causes green frames on some video content.
