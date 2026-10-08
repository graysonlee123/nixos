# Syncthing

Peer-to-peer file sync across all devices. Three folders are synced: Personal, Tarn, and Inspry (ids `personal`, `tarn`, `inspry`).

- Corbelan/Nostromo: `~/syncthing/<id>` (e.g. `~/syncthing/personal`)
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

Every folder uses staggered file versioning (30-day retention, hourly cleanup), set per folder in `data/syncthing.nix`. Old versions are stored in `.stversions` within each folder. This means accidental deletes or overwrites are recoverable from any device.

## Ignore Patterns

Ignore patterns exclude common unwanted files (.git, node_modules, build artifacts, editor files, OS junk). They are declared once in `data/syncthing.nix` (`ignorePatterns`) and applied to every folder via Nix, not a hand-edited `.stignore`.

## Configuration

- Shared device/folder/ignore data: `data/syncthing.nix`
- Corbelan/Nostromo: `modules/home/system/syncthing.nix`
- Sulaco: `modules/nixos/services/syncthing.nix` (NixOS-level service, GUI auth via sops)
- GUI: accessible at `http://localhost:8384` on each device
- Sulaco GUI: also accessible at `https://syncthing.lab.ggantek.net`
- Caddy reverse proxy requires `header_up Host localhost:8384` to avoid Syncthing's "Host check error" ([docs](https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api))
