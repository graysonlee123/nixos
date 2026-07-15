# Syncthing

Peer-to-peer file sync across all devices. Syncs `~/syncthing` folder.

## Devices

| Device   | Role        | Management         | Always On |
| -------- | ----------- | ------------------ | --------- |
| Corbelan | Laptop      | Nix (Home Manager) | No        |
| Nostromo | Desktop     | Nix (Home Manager) | No        |
| Sulaco   | Home server | Nix (NixOS module) | Yes       |

Sulaco acts as an always-on peer, ensuring corbelan and nostromo can sync even when the other is off. Without sulaco, both devices must be online simultaneously to exchange files.

## Networking

All devices connect via Tailscale. Sulaco also advertises a LAN address for faster local transfers.

## Versioning

All three devices use staggered file versioning (30-day retention, hourly cleanup). Old versions stored in `.stversions` within the sync folder. This means accidental deletes or overwrites are recoverable from any device.

## Ignore Patterns

`~/syncthing/.stignore` excludes common unwanted files (.git, node_modules, build artifacts, editor files, OS junk). This file itself syncs across all devices.

## Configuration

- Shared device/folder/ignore data: `data/syncthing.nix`
- Corbelan/Nostromo: `modules/home-manager/syncthing.nix`
- Sulaco: `modules/nixos/syncthing.nix` (NixOS-level service, GUI auth via sops)
- GUI: accessible at `http://localhost:8384` on each device
- Sulaco GUI: also accessible at `https://syncthing.lab.ggantek.net`
- Caddy reverse proxy requires `header_up Host localhost:8384` to avoid Syncthing's "Host check error" ([docs](https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api))
