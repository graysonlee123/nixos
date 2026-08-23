# NixOS Configuration - Repository Notes

Version-controlled NixOS config using **Nix flakes**. Modular: per-host configs + reusable modules. See `README.md` for full documentation.

## Machines

- **Corbelan**: Laptop (AMD CPU/GPU, Hi-DPI display) — headed
- **Nostromo**: Home desktop (Intel CPU, NVIDIA GPU) — headed
- **Sulaco**: Headless server (LAN DNS/DHCP, self-hosted services, game servers)

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
