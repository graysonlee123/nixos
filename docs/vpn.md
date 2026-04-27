# VPN

## NordVPN (via OpenVPN)

VPN connections use OpenVPN with `.ovpn` config files downloaded from the NordVPN dashboard. Config files contain server address, CA cert, and TLS key — stored outside the repo at `/etc/openvpn/`.

**Components:**

- **`openvpn`** (`modules/nixos/system-packages.nix`) — OpenVPN client
- **`/etc/openvpn/us11617.nordvpn.com.tcp.ovpn`** — dedicated IP config (TCP, not in repo, contains secrets)
- **`/etc/openvpn/nordvpn-auth.txt`** — service credentials (not in repo); format: username on line 1, password on line 2

NordVPN provides `.ovpn` configs for all servers (not just dedicated IPs) via the manual setup section of the dashboard. Service credentials are separate from your account login.

**Setup:**

1. Download a `.ovpn` config from the NordVPN dashboard
2. `sudo mkdir -p /etc/openvpn`
3. Place config at `/etc/openvpn/<name>.ovpn` with `sudo chmod 600`
4. Create `/etc/openvpn/nordvpn-auth.txt` (root:root, 600) with service credentials
5. Update the `auth-user-pass` line in the `.ovpn` to point to the auth file:
   ```bash
   sudo sed -i 's|auth-user-pass|auth-user-pass /etc/openvpn/nordvpn-auth.txt|' /etc/openvpn/<name>.ovpn
   ```

**Usage:**

```bash
sudo openvpn --config /etc/openvpn/us11617.nordvpn.com.tcp.ovpn
```

## Mullvad VPN

Mullvad is managed via `services.mullvad-vpn` (system daemon) and includes a custom Waybar module (`modules/home-manager/mullvad-waybar.nix`).

**Waybar module behavior:**

- Shows `󰒃 <exit IP>` in green when connected; tooltip shows city, country, and server hostname
- Shows `󰒃 ...` in yellow while connecting
- Hidden when disconnected
- Click to disconnect

**Live refresh:**

A systemd user service (`mullvad-waybar-listener`) runs `mullvad status listen` in the background and sends `SIGRTMIN+11` to waybar on each status change, triggering an immediate update rather than waiting for the 30s polling interval.

**Local network access:**

Mullvad blocks LAN by default — leave it that way. If you need LAN access temporarily:

```bash
mullvad lan set allow   # enable
mullvad lan set block   # re-block when done
```

Note: Docker port bindings should use `127.0.0.1:PORT:PORT` (not `PORT:PORT`) so dev services stay on loopback and LAN sharing is never needed.
