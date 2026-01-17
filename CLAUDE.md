# NixOS Configuration - Repository Notes

## Overview

This repository contains a version-controlled NixOS configuration using the home directory + symlinks approach. The configuration files are maintained in this git repository and symlinked to `/etc/nixos/` for system use.

## Repository Structure

```
~/repos/me/nixos/
├── .git/                       # Git repository
├── .gitignore                  # Git ignore rules
├── configuration.nix           # Main NixOS configuration
├── hardware-configuration.nix  # Hardware-specific settings
├── CLAUDE.md                   # This file - repository notes
└── README.md                   # User-facing documentation
```

## Active Symlinks

The following symlinks are currently active in `/etc/nixos/`:
- `/etc/nixos/configuration.nix` → `/home/gray/repos/me/nixos/configuration.nix`
- `/etc/nixos/hardware-configuration.nix` → `/home/gray/repos/me/nixos/hardware-configuration.nix`

## Configuration Approach

This setup uses the **home directory + symlinks** method for managing NixOS configuration:

### Benefits
- Git operations don't require sudo
- Easy to backup and share
- Clean separation between system config and version control
- Standard approach used by the NixOS community

### How It Works
1. Configuration files are stored in this git repository
2. `/etc/nixos/` contains symlinks pointing to the repository files
3. Changes are made in the repository, then applied with `nixos-rebuild`
4. Git tracks all configuration changes over time

## Recent Configuration Changes

Based on git history:
- Reordered packages; added pnpm
- Replaced Oh My Zsh with Starship prompt
- Refactored shell config to home-manager and updated fonts
- Added comprehensive README documenting NixOS configuration
- Added Yazi (terminal file manager) and Zoxide (smarter cd command)

## Current System Configuration

See `README.md` for comprehensive documentation. Key components include:
- **Window Manager**: Sway (Wayland compositor)
- **Terminal**: Ghostty with JetBrains Mono
- **Shell**: Zsh with Starship prompt
- **Package Management**: Home Manager for user-level packages
- **Development Tools**: Git, Docker, Go, Node.js, Claude Code, VS Code, PhpStorm
- **Utilities**: Yazi, Zoxide, pnpm, 1Password, and more

## Workflow

When making configuration changes:
1. Edit files in this repository
2. Test: `sudo nixos-rebuild test`
3. Commit: `git add . && git commit -m "description"`
4. Apply: `sudo nixos-rebuild switch`
5. Push to remote (if configured): `git push`
