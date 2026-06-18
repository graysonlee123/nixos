# Syncthing

Peer-to-peer file sync across all devices. Syncs `~/syncthing` folder.

## Devices

| Device | Role | Management | Always On |
|--------|------|------------|-----------|
| Corbelan | Laptop | Nix (Home Manager) | No |
| Nostromo | Desktop | Nix (Home Manager) | No |
| Sulaco | Home server | Docker Compose | Yes |

Sulaco acts as an always-on peer, ensuring corbelan and nostromo can sync even when the other is off. Without sulaco, both devices must be online simultaneously to exchange files.

## Networking

All devices connect via both Tailscale and LAN addresses. Tailscale handles remote sync, LAN addresses enable faster local transfers.

## Versioning

All three devices use staggered file versioning (30-day retention, hourly cleanup). Old versions stored in `.stversions` within the sync folder. This means accidental deletes or overwrites are recoverable from any device.

- Corbelan/Nostromo: configured in `modules/home-manager/syncthing.nix`
- Sulaco: configured via Syncthing web GUI

## Ignore Patterns

`~/syncthing/.stignore` excludes common unwanted files (.git, node_modules, build artifacts, editor files, OS junk). This file itself syncs across all devices.

## Sulaco Docker Compose

```yaml
services:
  syncthing:
    image: syncthing/syncthing
    container_name: syncthing
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - ./data:/var/syncthing
    network_mode: host
```

`network_mode: host` required for LAN discovery (UDP broadcast on port 21027).

## Configuration

- Corbelan/Nostromo: `modules/home-manager/syncthing.nix` manages devices, folders, and versioning declaratively
- Sulaco: Docker Compose with `network_mode: host` for LAN discovery support
- GUI: accessible at `http://localhost:8384` on each device
- Sulaco GUI: also accessible at `https://syncthing.lab.ggantek.net`
