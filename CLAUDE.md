# NixOS Configuration - Repository Notes

## Overview

This repository contains a version-controlled NixOS configuration using **Nix flakes**. Configuration is modular with separate host configs and reusable modules.

## Machines

- **Corbelan**: Laptop (AMD CPU/GPU, Hi-DPI display) — headed
- **Nostromo**: Home desktop (Intel CPU, NVIDIA GPU) — headed
- **Sulaco**: Headless server (LAN DNS/DHCP, self-hosted services, game servers)

## Repository Structure

```
~/repos/me/nixos/
├── flake.nix                  # Flake configuration
├── flake.lock                 # Flake lock file
├── assets/images/             # Wallpapers and images
├── data/                      # Shared data (hosts, constants, collections)
├── docs/                      # Extended documentation
├── hosts/                     # Per-host configs (corbelan, nostromo, sulaco)
├── lib/                       # Shared utility functions
├── modules/
│   ├── nixos/                 # System modules, grouped by category:
│   │   ├── core/              #   boot, users, sudo, docker, xdg, greeter
│   │   ├── system/            #   sops, gcp
│   │   ├── theme/             #   stylix
│   │   ├── network/           #   networking, openssh, tailscale, mullvad
│   │   ├── hardware/          #   gpu, bluetooth, fingerprint, audio
│   │   ├── security/          #   1password, clamav, keyring
│   │   ├── desktop/           #   sway
│   │   ├── gaming/            #   steam, gamemode
│   │   └── services/          #   headless services
│   └── home/                  # Home Manager modules, grouped by category:
│       ├── cli/               #   terminal tools
│       ├── dev/               #   git, go, editors
│       ├── desktop/           #   sway, waybar, cursor
│       ├── apps/              #   GUI apps
│       ├── pim/               #   calendars, contacts
│       └── system/            #   env, sops, ssh, xdg, syncthing
├── profiles/                  # Aggregators selecting module sets per host
│   ├── base.nix               #   shared by all hosts
│   ├── headed.nix             #   desktop hosts (imports base)
│   ├── headless.nix           #   servers (imports base)
│   └── home/                  #   matching Home Manager profiles
├── secrets/                   # sops-encrypted secrets
├── claude/                    # Claude Code skills
├── users/gray.nix             # User module (HM wiring + SSH keys)
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

Leaf modules are grouped by category; **profiles** are aggregators that select which modules activate. Folder = category, profile = activation (independent — e.g. some `core/` modules are headed-only).

- `modules/nixos/<category>/` - System modules (root), one program/service per file
- `modules/home/<category>/` - Home Manager modules (per-user programs, dotfiles)
- `profiles/{base,headed,headless}.nix` - System profiles; `headed`/`headless` import `base`. Hosts import one.
- `profiles/home/{base,headed,headless}.nix` - Matching HM profiles + package lists; wired via `users/gray.nix`.
- `lib/` - Shared utility functions
- `data/` - Shared data consumed by modules (hosts, constants, collections)
- `users/gray.nix` - NixOS module: defines `gray` options, HM wiring, SSH keys

When adding a module: drop the leaf file in the right `<category>/`, then add its import to the appropriate profile (not the host).
