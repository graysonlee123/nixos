# NixOS Configuration

Personal NixOS configuration using flakes for declarative system management.

## Overview

This repository contains my declarative NixOS system configuration, including:

- **Window Manager**: Sway (Wayland compositor)
- **Terminal**: Ghostty with JetBrains Mono
- **Shell**: Zsh with Starship prompt
- **Display Manager**: ly (Corbelan), greetd with tuigreet (Nostromo)
- **Development**: Docker, Git, Go, Node.js, various IDEs

## Repository Structure

```
<project-root>/
├── flake.nix                       # Flake configuration
├── flake.lock                      # Flake lock file
├── wallpaper.jpg                   # Desktop wallpaper
├── hosts/
│   ├── corbelan/                   # Laptop configuration
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── nostromo/                   # Desktop configuration
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── modules/
│   ├── nixos/                      # System-level modules (boot, services, drivers)
│   ├── home-manager/               # User-level modules (programs, configs)
│   ├── devices/                    # Device-specific configs
│   └── utils/                      # Utility modules (bookmark helpers)
└── scripts/                        # Helper scripts
```

This configuration uses flakes, so you can rebuild directly from the repository without symlinks:

```bash
# Rebuild current host (auto-detected)
sudo nixos-rebuild <option> --flake .

# Rebuild specific host
sudo nixos-rebuild <option> --flake .#<host>
```

## Setup Instructions

### Prerequisites

1. Setup internet if necessary:

```bash
# Connect to a WiFi network
nmcli device wifi connect <ssid> password <password>
```

2. Ensure flakes are enabled:

```bash
# Add to /etc/nixos/configuration.nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

### Initial Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/graysonlee123/nixos
   cd nixos
   ```

2. Build and activate the configuration:
   ```bash
   # For current host (auto-detected)
   sudo nixos-rebuild switch --flake .

   # Or specify a host
   sudo nixos-rebuild switch --flake .#corbelan
   sudo nixos-rebuild switch --flake .#nostromo
   ```

### Tailscale

If you want to connect to your Tailscale network, you'll have to [create a key](https://login.tailscale.com/admin/machines/new-linux) and authenticate:

```shell
sudo tailscale up --auth-key=KEY
```

## System Configuration Highlights

### System Packages
- curl, inxi
- ClamAV (antivirus)
- Fonts: Agave Nerd Font, Lora, Work Sans (via Stylix)

### User Packages (via Home Manager)
- **Productivity**: 1Password, Obsidian, Discord, Heynote
- **Development**: Claude Code, VS Code, PhpStorm, Docker, Git
- **Languages**: Go (with gopls), Node.js 24, PHP 8.2 (with Composer)
- **Browsers**: Chromium (with WideVine)
- **File Management**: FileZilla, Yazi
- **System Monitoring**: btop, dust, dive, neofetch
- **Database Tools**: pgcli, mycli, pgadmin4 (desktop mode)
- **Git Tools**: lazygit, git-crypt
- **Docker Tools**: lazydocker
- **Terminal Tools**: vim, fzf, ripgrep, tealdeer, zoxide
- **Utilities**: wl-clipboard, wp-cli, rclone, restic, satty (screenshots)
- **Communication**: iamb (Matrix client)
- **Media**: vlc, wf-recorder
- **Entertainment**: 2048-in-terminal, asciiquarium, crawl, nethack, tuir
- **Other**: tree, zip/unzip, jq, nixfmt, dig, speedtest-cli, pnpm 

### Audio

PipeWire with ALSA and PulseAudio compatibility layers (`modules/nixos/audio.nix`):

- **PipeWire**: The primary audio server, replacing the older PulseAudio and JACK servers. Handles routing audio between apps and hardware devices.
- **ALSA compat** (`alsa.enable`): Exposes a virtual ALSA device backed by PipeWire, so apps that use ALSA directly (instead of PulseAudio) still work.
- **PulseAudio compat** (`pulse.enable`): Runs a PulseAudio socket emulator so apps built against the PulseAudio API work without modification.
- **rtkit**: Grants PipeWire real-time scheduling priority, reducing audio latency and preventing dropouts under CPU load.

**Hardware mic gain (e.g. Samson Q9U):** The OS volume slider controls PipeWire's software gain — it doesn't affect the hardware capture level. If your mic is quiet even at 100%, the hardware gain may be set low. Check it via `alsamixer` (available via `nix shell nixpkgs#alsa-utils`), press `F6` to select the physical device, then `F4` for capture controls.

### Services
- OpenSSH daemon
- Docker daemon
- NetworkManager

### Sway Configuration
- **Modifier**: Super/Windows key (Mod4)
- **Terminal**: Ghostty
- **App Launcher**: Vicinae (Mod+d)
- **Status Bar**: Waybar
- Custom keybindings for window management and workspaces

### Terminal Setup
- **Font**: JetBrains Mono Nerd Font
- **Theme**: Rose Pine Moon
- **Shell**: Zsh with Starship prompt

### Git Configuration
Git is configured with conditional includes that automatically switch email addresses based on repository location:

- **Default**: `github@graysn.com` for personal projects
- **Work**: `grayson@inspry.com` for repositories in `~/repos/inspry/`

#### Multiple GitHub Accounts with SSH

The configuration handles multiple GitHub accounts (personal + work) using SSH config aliases combined with Git URL rewriting:

**How it works:**

1. **SSH Config** (`modules/home-manager/ssh.nix`):
   - `github.com` → personal key (`~/.ssh/github`)
   - `inspry.github.com` → work key (`~/.ssh/github-inspry`)

2. **Git URL Rewriting** (`modules/home-manager/git.nix`):
   - In `~/repos/inspry/`: Git auto-rewrites `git@github.com:inspry/` → `git@inspry.github.com:inspry/`
   - SSH config then routes to work key

3. **Result**: Use standard GitHub URLs everywhere. In work dir, URLs auto-rewrite to use work key.

**Benefits:**
- No manual URL editing for work repos
- Submodules work seamlessly (before, this was a big issue)
- Clone with standard URLs: `git clone git@github.com:inspry/repo`
- Git handles URL rewriting transparently

### Zoxide - Smart Directory Navigation
Zoxide tracks your most used directories and lets you jump to them quickly:

- `z <pattern>` - Jump to the highest-ranked directory matching the pattern
- `zi <pattern>` - Interactive selection when multiple directories match
- `zoxide query <pattern>` - Show which directory would be selected without jumping

Example: After visiting `/home/gray/repos/me/nixos` a few times, you can jump there with just `z nix`.

### Declarative Bookmark Management

Chromium bookmarks are managed declaratively through `modules/home-manager/bookmarks.nix`, which provides:

- **Separate profiles**: Personal and work bookmarks in different Chromium profiles
- **Read-only enforcement**: Bookmarks can only be changed via Nix configuration
- **Version controlled**: All bookmarks tracked in git
- **Encrypted**: Bookmark contents encrypted using git-crypt

**How it works:**

1. **`mkBookmark`**: Creates a single bookmark in Chromium's format
2. **`mkFolder`**: Creates a bookmark folder that can contain bookmarks/folders
3. **`convertBookmark`**: Recursively converts simple bookmark definitions to Chromium format
4. **`mkChromiumBookmarks`**: Generates the complete Chromium bookmarks JSON file

## Host-Specific Configurations

### Corbelan (Laptop)

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

### Nostromo (Desktop)

- **CPU**: Intel
- **Graphics**: NVIDIA with open-source drivers
- **GPU Configuration**:
  - `hardware.nvidia.open = true`
  - `hardware.nvidia.modesetting.enable = true`
- **Chromium green screen on videos**: Disable `chrome://flags/#disable-accelerated-video-decode` (set to Disabled). NVIDIA + Wayland hardware video decode causes green frames on some video content.

## VPN (NordVPN via OpenVPN)

VPN connections use OpenVPN with `.ovpn` config files downloaded from the NordVPN dashboard. Config files contain server address, CA cert, and TLS key — stored outside the repo at `/etc/openvpn/`.

**Components:**

- **`openvpn`** (`modules/nixos/system-packages.nix`) — OpenVPN client
- **`/etc/openvpn/us11617.nordvpn.com.tcp.ovpn`** — dedicated IP config (TCP, not in repo, contains secrets)
- **`/etc/openvpn/nordvpn-auth.txt`** — service credentials (not in repo); format: username on line 1, password on line 2

NordVPN provides `.ovpn` configs for all servers (not just dedicated IPs) via the manual setup section of the dashboard. Service credentials are separate from your account login.

**Setup:**

1. Download a `.ovpn` config from the NordVPN dashboard
2. `sudo mkdir -p /etc/openvpn`
3. Place config at `/etc/openvpn/<name>.ovpn` with `sudo chmod 600`
4. Create `/etc/openvpn/nordvpn-auth.txt` (root:root, 600) with service credentials
5. Update the `auth-user-pass` line in the `.ovpn` to point to the auth file:
   ```bash
   sudo sed -i 's|auth-user-pass|auth-user-pass /etc/openvpn/nordvpn-auth.txt|' /etc/openvpn/<name>.ovpn
   ```

**Usage:**

```bash
sudo openvpn --config /etc/openvpn/us11617.nordvpn.com.tcp.ovpn
```

## Mullvad VPN

Mullvad is managed via `services.mullvad-vpn` (system daemon) and includes a custom Waybar module (`modules/home-manager/mullvad-waybar.nix`).

**Waybar module behavior:**

- Shows `󰒃 <exit IP>` in green when connected; tooltip shows city, country, and server hostname
- Shows `󰒃 ...` in yellow while connecting
- Hidden when disconnected
- Click to disconnect

**Live refresh:**

A systemd user service (`mullvad-waybar-listener`) runs `mullvad status listen` in the background and sends `SIGRTMIN+11` to waybar on each status change, triggering an immediate update rather than waiting for the 30s polling interval.

**Local network access:**

Mullvad blocks LAN by default — leave it that way. If you need LAN access temporarily:

```bash
mullvad lan set allow   # enable
mullvad lan set block   # re-block when done
```

Note: Docker port bindings should use `127.0.0.1:PORT:PORT` (not `PORT:PORT`) so dev services stay on loopback and LAN sharing is never needed.

## Useful Commands

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .

# Test configuration without making it default
sudo nixos-rebuild test --flake .

# Check for syntax errors
sudo nixos-rebuild build --flake .

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Clean up old generations
sudo nix-collect-garbage -d

# Update flake inputs
nix flake update
```

## Useful Keybindings

- `Print`: Screenshot with grim, satty and slurp
- `Super + Print`: Open screen recording menu (region/fullscreen, with/without audio) via Vicinae. If a recording is already in progress, stops it immediately.

## Voice Dictation

Push-to-talk dictation using whisper-cpp. Press `Super+M` to start recording, press again to stop, transcribe, and type the result into the focused window. Uses PipeWire's default audio source.

A waybar indicator shows `󰍬 REC` (red) while recording and `󰓆 ...` (yellow) while transcribing.

**Setup:** download a whisper model and place it at `~/.local/share/whisper/model.bin`:
```bash
whisper-cpp-download-ggml-model base.en
mv ggml-base.en.bin ~/.local/share/whisper/model.bin
```

## XDG MIME Defaults

Default applications are configured in `modules/home-manager/xdg.nix` via `xdg.mimeApps.defaultApplications`. Note that XDG MIME wildcards (e.g. `video/*`) don't work in `mimeapps.list` — each MIME type must be listed explicitly.

However, many associations happen automatically without explicit configuration. Apps like VLC declare supported MIME types in their `.desktop` files, which get indexed into `mimeinfo.cache`. The XDG lookup chain is:

1. **`mimeapps.list`** (explicit defaults from xdg.nix)
2. **`mimeinfo.cache`** (built from installed apps' `.desktop` files)

So explicit entries in xdg.nix are only needed when you want to *override* what installed apps already claim. For example, VLC already advertises support for most media types, so it wins by default without any xdg.nix entry.

### XDG Desktop Portals

XDG desktop portals provide sandboxed apps (Flatpaks, Electron apps) controlled access to system resources on Wayland. Configured in `modules/nixos/xdg.nix` using `xdg-desktop-portal-wlr` for Sway. Enables:

- File picker dialogs in browsers and apps
- Screen sharing/recording in web apps
- Screenshot capabilities across sandbox boundaries

## Minecraft (via Prism Launcher)

Prism Launcher is installed via nixpkgs and has much better overall compatibility than ATLauncher.

### Streaming audio via Vesktop

Minecraft runs on the JVM, so its PipeWire audio stream is registered as `java` with no application name. Vesktop filters unnamed streams and won't show it as an audio source.

Fix: in the Prism Launcher instance settings, add this environment variable:

```
PIPEWIRE_PROPS=application.name=Minecraft
```

After relaunching, Minecraft will appear as "Minecraft" in Vesktop's audio source picker.

### Mic cuts out when streaming

Vesktop auto-switches input/output devices when a new audio source appears (e.g. the Minecraft stream). Fix: set input and output devices explicitly in Vesktop's Voice & Video settings instead of using "Default".

## Gamescope (Steam Game Scaling)

Gamescope is a micro-compositor for scaling games. Key flags:

- `-w` / `-h` — game (inner) resolution
- `-W` / `-H` — output (display) resolution
- `-S` / `--scaler` — scaling mode: `auto`, `integer`, `fit`, `fill`, `stretch`
- `-F` / `--filter` — upscale filter: `linear`, `nearest`, `fsr`, `nis`, `pixel`

### Corbelan (2880x1800)

For integer scaling, the game resolution must divide evenly into the output resolution. Common clean ratios for 1800p:

| Game height | Scale factor | Notes |
|-------------|-------------|-------|
| 900 | 2x | Good default for most games |
| 600 | 3x | Ideal for old 800x600 games |
| 450 | 4x | Very low res |

General template:
```
gamescope -w <game_w> -h <game_h> -W 2880 -H 1800 -S integer -F nearest --fullscreen -- %command%
```

If integer scaling doesn't work (game res doesn't divide evenly), use `fit` + `fsr`:
```
gamescope -w <game_w> -h <game_h> -W 2880 -H 1800 -S fit -F fsr --fullscreen -- %command%
```

### Peggle Deluxe (800x600)

Native 800x600 → 3x integer to 1800p. Uses `PROTON_USE_WINED3D=1` to fix game speed issues caused by Proton's DXVK timing with old DirectX games.

```
PROTON_USE_WINED3D=1 gamescope -w 800 -h 600 -W 2880 -H 1800 --scaler integer --filter nearest --fullscreen -- %command%
```

## PHP Development (WordPress)

PHP 8.2, Composer, and wp-cli are via Nix. `phpcs`/`phpcbf` and WPCS are via Composer global (`~/.config/composer/vendor/bin` is on `PATH`).

**First-time setup:**
```bash
composer global require wp-coding-standards/wpcs dealerdirect/phpcodesniffer-composer-installer
```

**Usage:**
```bash
phpcs --standard=WordPress file.php   # check
phpcbf --standard=WordPress file.php  # fix
```

Add `phpcs.xml` to a project root to avoid repeating `--standard=WordPress` and to exclude `vendor/` etc., then run `phpcs .`:

```xml
<?xml version="1.0"?>
<ruleset>
    <rule ref="WordPress"/>
    <exclude-pattern>vendor/</exclude-pattern>
    <exclude-pattern>node_modules/</exclude-pattern>
</ruleset>
```

## Bluetooth

Managed with `bluetui` (TUI). Run `bluetui` to scan and pair devices.

## Notes

- This configuration uses flakes and Home Manager for user-specific settings
- Unfree packages are enabled both system-wide and for the user
- Hardware configuration should not be manually edited (auto-generated)
- Each host has its own configuration directory under `hosts/`

## License

Personal configuration - use at your own risk.
