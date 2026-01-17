# NixOS Configuration Setup - Conversation Log

## Goal
Set up version control for NixOS configuration using the home directory + symlinks approach (most popular method).

## Current Status
- ✅ Created `~/nixos-config/` directory
- ✅ Copied `configuration.nix` and `hardware-configuration.nix` from `/etc/nixos/`
- ✅ Created `.gitignore` file
- ⏸️ **Blocked**: Git is not installed on the system

## Next Steps
1. Install Git (either via nix-shell or add to configuration.nix)
2. Initialize Git repository
3. Create initial commit
4. Replace files in `/etc/nixos/` with symlinks to `~/nixos-config/`
5. Verify symlinks work correctly
6. Test configuration with `sudo nixos-rebuild test`

## Approach Chosen: Home Directory + Symlinks

### Why this approach?
- Easy to manage without sudo for Git operations
- Easy to backup and share
- Clean separation between system config and version control

### Directory Structure
```
~/nixos-config/
├── .gitignore
├── configuration.nix
├── hardware-configuration.nix
└── CLAUDE.md (this file)

/etc/nixos/
├── configuration.nix -> ~/nixos-config/configuration.nix (symlink - pending)
└── hardware-configuration.nix -> ~/nixos-config/hardware-configuration.nix (symlink - pending)
```

## Current Blocker
Git is not installed. Need to either:
- **Option A**: `nix-shell -p git` (temporary, quick start)
- **Option B**: Add git to configuration.nix, rebuild, then continue

**NOTE**: Claude Code does not have sudo access, so user must manually:
1. Add `git` to `home.packages` in configuration.nix (line 155-172, inside home-manager.users.gray section)
2. Run `sudo nixos-rebuild switch`
3. Verify with `git --version`

**Rationale**: Git added as user package (not system package) because:
- More idiomatic with home-manager
- Matches existing pattern (dev tools like go, nodejs, vscode are in user packages)
- Keeps system packages minimal

## Files in /etc/nixos/
- configuration.nix (9000 bytes)
- hardware-configuration.nix (959 bytes)
- .configuration.nix.swp (editor swap file - will be ignored)
