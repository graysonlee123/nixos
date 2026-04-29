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
├── docs/                           # Extended documentation
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

See [docs/audio.md](docs/audio.md).

### ClamAV

Virus signatures auto-updated via `services.clamav.updater`. Run a manual scan monthly:

```bash
clamscan -r --bell -i /home/gray
```

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

See [docs/git.md](docs/git.md).

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

See [docs/hosts.md](docs/hosts.md).

## VPN

See [docs/vpn.md](docs/vpn.md).

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

## Gaming

See [docs/gaming.md](docs/gaming.md).

## Development

See [docs/development.md](docs/development.md).

## Bluetooth

Managed with `bluetui` (TUI). Run `bluetui` to scan and pair devices.

## Notes

- This configuration uses flakes and Home Manager for user-specific settings
- Unfree packages are enabled both system-wide and for the user
- Hardware configuration should not be manually edited (auto-generated)
- Each host has its own configuration directory under `hosts/`

## License

Personal configuration - use at your own risk.
