# NixOS Configuration - Repository Notes

## Overview

This repository contains a version-controlled NixOS configuration using **Nix flakes**. Configuration is modular with separate host configs and reusable modules.

## Machines

- **Corbelan**: Laptop (AMD CPU/GPU, Hi-DPI display)
- **Nostromo**: Home desktop (Intel CPU, NVIDIA GPU)

## Repository Structure

```
~/repos/me/nixos/
├── flake.nix                   # Flake configuration
├── flake.lock                  # Flake lock file
├── hosts/
│   ├── corbelan/              # Laptop configuration
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── nostromo/              # Desktop configuration
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── modules/
│   ├── nixos/                 # System-level modules
│   ├── home-manager/          # User-level modules
│   ├── devices/               # Device-specific configs
│   └── utils/                 # Utility modules (bookmarks)
├── scripts/                   # Helper scripts
├── wallpaper.jpg
├── CLAUDE.md                  # This file
└── README.md                  # User-facing documentation
```

## Configuration Approach

Uses **Nix flakes** with modular architecture:

### Benefits
- Reproducible builds with flake.lock
- No symlinks needed - rebuild directly from repo
- Clean module separation by purpose
- Version-controlled dependencies

### How It Works
1. Edit config files in this repository
2. Rebuild: `sudo nixos-rebuild switch --flake .`
3. Flake auto-detects hostname and applies correct config
4. Git tracks all configuration changes

## Current System Configuration

See `README.md` for comprehensive documentation. Key components:
- **Window Manager**: Sway (Wayland)
- **Terminal**: Ghostty 
- **Shell**: Zsh with Starship
- **Package Management**: Home Manager for user packages
- **Development**: Git, Docker, Go, Node.js, Claude Code, VS Code, PhpStorm
- **Utilities**: Yazi, Zoxide, btop, lazygit, lazydocker, and more

## Workflow

Making config changes:
1. Edit files in this repository
2. Test: `sudo nixos-rebuild test --flake .`
3. Apply: `sudo nixos-rebuild switch --flake .`
4. Commit: `git add . && git commit -m "description"`
5. Push: `git push`

## Module Organization

- `modules/nixos/` - System services, packages, configs requiring root
- `modules/home-manager/` - User programs, dotfiles, per-user settings
- `modules/devices/` - Device-specific configs (e.g., Galaxy70 MTP)
- `modules/utils/` - Shared utility functions (bookmark helpers)
