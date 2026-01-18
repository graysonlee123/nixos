# NixOS Configuration

Personal NixOS configuration using the home directory + symlinks approach for version control.

## Overview

This repository contains my declarative NixOS system configuration, including:

- **Window Manager**: Sway (Wayland compositor)
- **Terminal**: Ghostty with JetBrains Mono
- **Shell**: Zsh with Oh My Zsh (agnoster theme)
- **Display Manager**: greetd with tuigreet
- **GPU**: NVIDIA with open-source drivers
- **Development**: Docker, Git, Go, Node.js, various IDEs

## Repository Structure

```
~/nixos-config/
├── configuration.nix          # Main NixOS configuration
├── hardware-configuration.nix # Hardware-specific settings (auto-generated)
├── .gitignore                 # Git ignore rules
├── CLAUDE.md                  # Conversation log
└── README.md                  # This file

/etc/nixos/
├── configuration.nix -> ~/nixos-config/configuration.nix
└── hardware-configuration.nix -> ~/nixos-config/hardware-configuration.nix
```

## Setup Instructions

### Initial Setup

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/nixos-config
   cd ~/nixos-config
   ```

2. Backup existing configuration (if not already done):
   ```bash
   sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.backup
   sudo cp /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.backup
   ```

3. Create symlinks to this repository:
   ```bash
   sudo rm /etc/nixos/configuration.nix
   sudo rm /etc/nixos/hardware-configuration.nix
   sudo ln -s ~/nixos-config/configuration.nix /etc/nixos/configuration.nix
   sudo ln -s ~/nixos-config/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
   ```

4. Test the configuration:
   ```bash
   sudo nixos-rebuild test
   ```

5. Apply changes permanently:
   ```bash
   sudo nixos-rebuild switch
   ```

### Making Changes

1. Edit configuration files in `~/nixos-config/`
2. Test changes: `sudo nixos-rebuild test`
3. Commit changes: `git add . && git commit -m "Description of changes"`
4. Apply permanently: `sudo nixos-rebuild switch`

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
- **Browsers**: Google Chrome
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
- **Status Bar**: i3status
- Custom keybindings for window management and workspaces

### Terminal Setup
- **Font**: JetBrains Mono 22pt
- **Theme**: Alien Blood
- **Shell**: Zsh with Oh My Zsh
- **Plugins**: git, man

### Zoxide - Smart Directory Navigation
Zoxide tracks your most used directories and lets you jump to them quickly:

- `z <pattern>` - Jump to the highest-ranked directory matching the pattern
- `zi <pattern>` - Interactive selection when multiple directories match
- `zoxide query <pattern>` - Show which directory would be selected without jumping

Example: After visiting `/home/gray/repos/me/nixos` a few times, you can jump there with just `z nix`.

## System Information

- **NixOS Version**: 25.11
- **Time Zone**: America/New_York
- **Locale**: en_US.UTF-8
- **Hostname**: nixos

## Useful Commands

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch

# Test configuration without making it default
sudo nixos-rebuild test

# Check for syntax errors
sudo nixos-rebuild build

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Clean up old generations
sudo nix-collect-garbage -d

# Update NixOS channels
sudo nix-channel --update
```

## Notes

- This configuration uses Home Manager for user-specific settings
- NVIDIA drivers are configured with open-source kernel modules
- Unfree packages are enabled both system-wide and for the user
- Hardware configuration should not be manually edited (auto-generated)

## License

Personal configuration - use at your own risk.
