# Syncthing

Peer-to-peer file sync across all devices. Four folders are synced: Personal, Tarn, Inspry, and ClaudeProjects (ids `personal`, `tarn`, `inspry`, `claude-projects`).

- Corbelan/Nostromo: `~/syncthing/<id>` (e.g. `~/syncthing/personal`), unless the folder sets `homePath` (relative to `$HOME`) in `data/syncthing.nix`
- Sulaco: `/var/lib/syncthing/<id>` (e.g. `/var/lib/syncthing/personal`). Config says `~/<id>`, but the service runs as the `syncthing` user, whose home is `/var/lib/syncthing`.

## Devices

| Device   | Role        | Management         | Always On |
| -------- | ----------- | ------------------ | --------- |
| Corbelan | Laptop      | Nix (Home Manager) | No        |
| Nostromo | Desktop     | Nix (Home Manager) | No        |
| Sulaco   | Home server | Nix (NixOS module) | Yes       |
| iPhone   | Phone       | Manual (app)       | No        |

Sulaco acts as an always-on peer, ensuring corbelan and nostromo can sync even when the other is off. Without sulaco, both devices must be online simultaneously to exchange files.

## Networking

All devices connect via Tailscale. Sulaco also advertises a LAN address for faster local transfers.

## Versioning

Every folder except ClaudeProjects uses staggered file versioning (30-day retention, hourly cleanup), set per folder in `data/syncthing.nix`. Old versions are stored in `.stversions` within each folder. This means accidental deletes or overwrites are recoverable from any device.

## Claude Code Sessions

The ClaudeProjects folder syncs `~/.claude/projects` (session `.jsonl` files and auto memory) on Corbelan and Nostromo, so `claude --resume` and project memory carry across machines. It is not shared with the iPhone.

- Session dirs are keyed by the absolute working directory (e.g. `-home-gray-repos-me-nixos`). Keep repos at the same path on every machine, or sessions will not line up.
- Sulaco only holds a relay copy at `/var/lib/syncthing/claude-projects`. Its Syncthing runs as the `syncthing` user, so Claude sessions started on Sulaco itself are not synced.
- No versioning: session files are appended constantly and would bloat `.stversions`.
- Do not keep the same session open on two machines at once, or Syncthing will create `.sync-conflict` files.

## Ignore Patterns

Ignore patterns exclude common unwanted files (.git, node_modules, build artifacts, editor files, OS junk). They are declared once in `data/syncthing.nix` (`ignorePatterns`) and applied to every folder via Nix, not a hand-edited `.stignore`.

## Configuration

- Shared device/folder/ignore data: `data/syncthing.nix`
- Corbelan/Nostromo: `modules/home/system/syncthing.nix`
- Sulaco: `modules/nixos/services/syncthing.nix` (NixOS-level service, GUI auth via sops)
- GUI: accessible at `http://localhost:8384` on each device
- Sulaco GUI: also accessible at `https://syncthing.lab.ggantek.net`
- Caddy reverse proxy requires `header_up Host localhost:8384` to avoid Syncthing's "Host check error" ([docs](https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api))
