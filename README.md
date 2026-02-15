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
├── bookmarks.nix                   # Declarative Chromium bookmarks
├── hosts/
│   ├── corbelan/                   # Laptop configuration
│   │   ├── configuration.nix       # Main system config
│   │   ├── hardware-configuration.nix
│   │   ├── need-to-integrate.nix   # Host-specific settings (to be integrated)
│   │   └── home.nix                # Home Manager config
│   └── nostromo/                   # Desktop configuration
│       ├── configuration.nix       # Main system config
│       ├── hardware-configuration.nix
│       └── home.nix                # Home Manager config
└── modules/
    └── nixos/
        ├── user.nix                # User configuration
        └── system-packages.nix     # System-wide packages
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

# Or use the TUI
nmtui
```

2. Ensure flakes are enabled:

```bash
# Add to /etc/nixos/configuration.nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

### Initial Setup

1. Clone this repository:
   ```bash
   git clone <repository-url> <project-root>
   cd <project-root>
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
- vim, curl, inxi
- JetBrains Mono (nerd fonts)

### User Packages (via Home Manager)
- **Productivity**: 1Password, Obsidian, Discord
- **Development**: Claude Code, VS Code, PhpStorm, Docker, Git
- **Languages**: Go, Node.js 24
- **Browsers**: Chromium
- **File Management**: FileZilla, Yazi
- **Utilities**: wl-clipboard, Zoxide

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
- Submodules work seamlessly
- Clone with standard URLs: `git clone git@github.com:inspry/repo`
- Git handles URL rewriting transparently

### Zoxide - Smart Directory Navigation
Zoxide tracks your most used directories and lets you jump to them quickly:

- `z <pattern>` - Jump to the highest-ranked directory matching the pattern
- `zi <pattern>` - Interactive selection when multiple directories match
- `zoxide query <pattern>` - Show which directory would be selected without jumping

Example: After visiting `/home/gray/repos/me/nixos` a few times, you can jump there with just `z nix`.

### Declarative Bookmark Management

Chromium bookmarks are managed declaratively through `bookmarks.nix`, which provides:

- **Separate profiles**: Personal and work bookmarks in different Chromium profiles
- **Read-only enforcement**: Bookmarks can only be changed via Nix configuration
- **Version controlled**: All bookmarks tracked in git

**File structure in `bookmarks.nix`:**

```nix
rec {
  # Helper functions that convert to Chromium format
  mkBookmark = name: url: { ... };
  mkFolder = name: children: { ... };
  convertBookmark = item: ...;
  mkChromiumBookmarks = bookmarkSet: ...;

  # Bookmark data
  personal = {
    bookmarks_bar = [ ... ];
    other = [ ... ];
  };

  work = {
    bookmarks_bar = [ ... ];
    other = [ ... ];
  };
}
```

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

## Notes

- This configuration uses flakes and Home Manager for user-specific settings
- Unfree packages are enabled both system-wide and for the user
- Hardware configuration should not be manually edited (auto-generated)
- Each host has its own configuration directory under `hosts/`

## License

Personal configuration - use at your own risk.
