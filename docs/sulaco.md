## Port Map

| Port  | Protocol | Service                   | Bind Address            | Firewall Open   | Notes                                        |
| ----- | -------- | ------------------------- | ----------------------- | --------------- | -------------------------------------------- |
| 22    | TCP      | SSH                       | 0.0.0.0                 | LAN + Tailscale |                                              |
| 53    | TCP/UDP  | AdGuard Home (DNS)        | 127.0.0.1, 192.168.86.2 | enp2s0          | LAN DNS                                      |
| 68    | TCP/UDP  | AdGuard Home (DHCP)       | 127.0.0.1, 192.168.86.2 | enp2s0          | LAN DNS                                      |
| 67    | TCP/UDP  | AdGuard Home (DHCP)       | 127.0.0.1, 192.168.86.2 | enp2s0          | LAN DNS                                      |
| 80    | TCP      | Caddy (HTTP)              | \*                      | Yes             | Redirect to HTTPS                            |
| 443   | TCP/UDP  | Caddy (HTTPS)             | \*                      | Yes             | Reverse proxy                                |
| 3000  | TCP      | AdGuard Home (Web)        | 127.0.0.1               | No              | Behind Caddy                                 |
| 3001  | TCP      | Uptime Kuma               | 127.0.0.1               | No              | Behind Caddy                                 |
| 3456  | TCP      | Vikunja                   | \*                      | No              | Firewall blocks                              |
| 4369  | TCP      | EPMD (Erlang)             | 0.0.0.0                 | No              | From Pinchflat runtime                       |
| 5232  | TCP      | Radicale (CalDAV/CardDAV) | 0.0.0.0                 | No              | Behind Caddy                                 |
| 5432  | TCP      | PostgreSQL                | 127.0.0.1, 172.17.0.1   | docker0 only    | Peer auth (host), password auth (containers) |
| 7359  | UDP      | Jellyfin (Discovery)      | 0.0.0.0                 | No              | DLNA/client discovery                        |
| 7777  | TCP      | Terraria                  | 0.0.0.0                 | Yes             | Game server                                  |
| 8096  | TCP      | Jellyfin                  | 127.0.0.1               | No              | Behind Caddy, bound in-app                   |
| 8384  | TCP      | Syncthing GUI             | 127.0.0.1               | No              | Behind Caddy                                 |
| 8945  | TCP      | Pinchflat                 | 0.0.0.0                 | No              | Firewall blocks, no bind option              |
| 9090  | TCP      | Linkding                  | 127.0.0.1               | No              | Docker port mapping                          |
| 9987  | UDP      | TeamSpeak (Voice)         | 0.0.0.0                 | Yes             |                                              |
| 10011 | TCP      | TeamSpeak (ServerQuery)   | 0.0.0.0                 | Yes             |                                              |
| 10022 | TCP      | TeamSpeak (SSH Query)     | 0.0.0.0                 | Yes             |                                              |
| 10080 | TCP      | TeamSpeak (WebQuery)      | 0.0.0.0                 | Yes             |                                              |
| 21027 | UDP      | Syncthing Discovery       | 0.0.0.0                 | Yes             |                                              |
| 22000 | TCP/UDP  | Syncthing Transfer        | \*                      | Yes             |                                              |
| 25565 | TCP      | Minecraft                 | 0.0.0.0                 | Yes             | Game server                                  |
| 30033 | TCP      | TeamSpeak (File Transfer) | 0.0.0.0                 | Yes             |                                              |
| 37537 | TCP      | Pinchflat (Erlang VM)     | 0.0.0.0                 | No              | BEAM distribution, firewall blocks           |
| 41641 | UDP/TCP  | Tailscale                 | 0.0.0.0                 | N/A             | WireGuard tunnel                             |
| 41739 | TCP      | Tailscale                 | 100.93.40.89            | N/A             | Tailscale service listener                   |

`sudo iptables -L nixos-fw -n` to verify firewall state.

---

- Uptime Kuma runs at `/var/lib/private/uptime-kuma`
- Jellyfin lives at `/var/lib/jellyfin`
- PostgreSQL at `/var/lib/postgresql/`
  - Peer auth via Unix socket, no passwords
  - Services connect through `/run/postgresql`
  - No remote access; use SSH to query
- linkding data lives at `/var/lib/linkding`

```shell
sudo -u postgres psql
```

Then \l to list databases, \c vikunja to connect to one, \dt to list tables.

Or using `pgcli` as `gray`:

```shell
pgcli vikunja
```

- Yes — each oci-containers entry becomes a systemd service (docker-<name>.service) that runs docker run. NixOS manages the lifecycle, not Docker. So docker ps only shows it while the service is active.

- Yes — if the container config changed, NixOS will restart the systemd service. If nothing changed in the container definition, it stays running.

- Docker uses Bind Mounts rather than named volumes

What NixOS postgres gives you:

- Declarative ensureDatabases/ensureUsers
- Managed major version upgrades
- Automatic backup integration
- peer auth for native services (vikunja)
- SystemD integration, journald logs

## Container-to-host networking

Docker creates a virtual bridge interface `docker0` with subnet `172.17.0.0/16`. The host is reachable from containers at `172.17.0.1` (the bridge gateway).

For containers to reach host services (e.g. PostgreSQL on port 5432):

1. Service must listen on `172.17.0.1` (not just `localhost`). For postgres: `listen_addresses = "localhost,172.17.0.1"`.
2. NixOS firewall must allow the port on `docker0`: `networking.firewall.interfaces."docker0".allowedTCPPorts = [ 5432 ]`. This opens the port only for container traffic, not the internet or LAN.
3. Containers use `172.17.0.1` as the host address in their config.

Auth: containers run as root (UID 0) inside, so PostgreSQL peer auth (which matches Unix UID to DB user) won't work. Use password auth (md5/scram-sha-256) for container connections. Store passwords in sops, pass to containers via `environmentFiles` and `sops.templates` to keep secrets out of the nix store (which is world-readable).

## Host-level services and PostgreSQL

Native NixOS services (e.g. Vikunja) run as system users matching their DB username. PostgreSQL peer auth works directly over Unix socket at `/run/postgresql` -- no password needed, UID maps to the correct DB role.

This is the key difference: host-level services use peer auth via socket, containerized services use password auth via TCP over the docker bridge.

## Jellyfin

### Configuration

In the Administrator dasboard, under Networking, set "Bind to local network address" to 127.0.0.1, since Jellyfin is served from behind a reverse proxy.s

### Jellyfin + Pinchflat

Jellyfin runs a user who is in the `pinchflat` (defualt name) group, so it can access `/var/lib/pinchflat`. Library settings that worked best:

- **Content Type**: Home Videos and Photos
- **Enable the library**: Enable
- **Prefer embedded titles over filenames**: Enable
- **Metadata savers**: None
- **Image fetchers**: None
- Disable everything else

### Jellyfin + Music

Todo
