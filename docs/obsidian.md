# Obsidian

Second brain app. Single vault named "tarn" (a mountain lake formed by glaciers). Notes linked via WikiLinks.

## Vault Location

Lives at `~/syncthing/tarn` on all machines. Syncthing is source of truth for sync -- no Obsidian Sync.

## Sync

All devices sync vault via Syncthing:

- **Nostromo** (desktop), **Corbelan** (laptop), **Sulaco** (server) -- native Syncthing
- **iPhone** -- Synctrain app, configured to sync into iOS Obsidian's local folder

Syncthing uses staggered versioning (30-day retention, hourly cleanup). See `data/syncthing.nix` and `modules/home-manager/syncthing.nix`.
