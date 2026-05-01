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

### Power Management

`auto-cpufreq` manages CPU frequency scaling across AC/battery transitions and post-sleep resume events. Configured via `modules/nixos/auto-cpufreq.nix`:

- **Charger**: `performance` governor, `performance` EPP
- **Battery**: `powersave` governor, `balance_power` EPP

```bash
# Monitor CPU governor, EPP, and frequency in real-time
sudo auto-cpufreq --monitor

# Check current EPP
cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference

# Check current frequency across all cores
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq
```

## Nostromo (Desktop)

- **CPU**: Intel
- **Graphics**: NVIDIA with open-source drivers
- **GPU Configuration**:
  - `hardware.nvidia.open = true`
  - `hardware.nvidia.modesetting.enable = true`
- **Chromium green screen on videos**: Disable `chrome://flags/#disable-accelerated-video-decode` (set to Disabled). NVIDIA + Wayland hardware video decode causes green frames on some video content.
