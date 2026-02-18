# NixOS Configuration

Personal NixOS configuration using flakes for declarative system management.

## Overview

This repository contains my declarative NixOS system configuration, including:

- **Window Manager**: Sway (Wayland compositor)
- **Terminal**: Ghostty with JetBrains Mono
- **Shell**: Zsh with Starship prompt
- **Display Manager**: greetd with tuigreet
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

### Nostromo (Desktop)

- **CPU**: Intel
- **Graphics**: NVIDIA with open-source drivers
- **GPU Configuration**:
  - `hardware.nvidia.open = true`
  - `hardware.nvidia.modesetting.enable = true`

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
- `Super + Print`: Screen record with wf-recorder and slurp
- `Super + Alt + Print`: Screen record with default audio source using wf-recorder and slurp
- `Super + Shift + Print`: Gracefully kill wf-recorder

## XDG MIME Defaults

Default applications are configured in `modules/home-manager/xdg.nix` via `xdg.mimeApps.defaultApplications`. Note that XDG MIME wildcards (e.g. `video/*`) don't work in `mimeapps.list` — each MIME type must be listed explicitly.

However, many associations happen automatically without explicit configuration. Apps like VLC declare supported MIME types in their `.desktop` files, which get indexed into `mimeinfo.cache`. The XDG lookup chain is:

1. **`mimeapps.list`** (explicit defaults from xdg.nix)
2. **`mimeinfo.cache`** (built from installed apps' `.desktop` files)

So explicit entries in xdg.nix are only needed when you want to *override* what installed apps already claim. For example, VLC already advertises support for most media types, so it wins by default without any xdg.nix entry.

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

## Notes

- This configuration uses flakes and Home Manager for user-specific settings
- Unfree packages are enabled both system-wide and for the user
- Hardware configuration should not be manually edited (auto-generated)
- Each host has its own configuration directory under `hosts/`

## License

Personal configuration - use at your own risk.
