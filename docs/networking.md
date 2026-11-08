# Networking

Network stack per host. Shared pieces come from `profiles/base.nix` (all hosts) and `profiles/headed.nix` (Corbelan, Nostromo).

## Shared

| Layer     | Module                                 | Notes                                                                |
| --------- | -------------------------------------- | -------------------------------------------------------------------- |
| Hostname  | `modules/nixos/network/networking.nix` | From `host.name`                                                     |
| IPv6      | `modules/nixos/network/networking.nix` | Disabled (`networking.enableIPv6 = false`)                           |
| Firewall  | `modules/nixos/network/networking.nix` | NixOS firewall (iptables). Opens Syncthing (22000/TCP, 21027/UDP) on all hosts; Xdebug (9003/TCP) on headed hosts |
| SSH       | `modules/nixos/network/openssh.nix`    | `services.openssh`; see [ssh.md](./ssh.md)                           |
| Tailscale | `modules/nixos/network/tailscale.nix`  | Mesh overlay (`tailscale0`). Headless auto-auths via `/etc/secrets/tailscale_key`; headed hosts auth manually (`sudo tailscale up`) |
| Mullvad   | `modules/nixos/network/mullvad.nix`    | Headed only. Blocks LAN by default; see [vpn.md](./vpn.md)           |
| Resolver  | NixOS default                          | `resolvconf` writes `/etc/resolv.conf`; `systemd-resolved` is off    |

Static device data (MACs, LAN/Tailscale IPs) lives in `data/hosts.nix`; gateway and default DNS in `data/constants.nix`.

## LAN topology

```
WAN <-- Router (192.168.86.1, gateway only, DHCP relay)
            |
            +-- Sulaco (192.168.86.2, static) -- AdGuard Home: DHCP + DNS for LAN
            +-- Nostromo (DHCP from AGH)
            +-- Corbelan (DHCP from AGH when home)
            +-- other devices (DHCP from AGH)
```

Details: [adguardhome.md](./adguardhome.md).

## Corbelan (Laptop)

| Layer         | Config                                                                      |
| ------------- | --------------------------------------------------------------------------- |
| Link manager  | Standalone **iwd** (no NetworkManager, no wpa_supplicant)                   |
| UI            | **Impala** (TUI for iwd); Waybar network module click opens it              |
| WiFi addressing | iwd built-in DHCP (`General.EnableNetworkConfiguration = true`)           |
| Wired addressing | dhcpcd (`networking.useDHCP` default); `wlan0` and Docker interfaces denied so it doesn't fight iwd |
| DNS           | iwd pushes DHCP-provided DNS to `resolvconf` (`Network.NameResolvingService`) |
| IPv6          | Off (also `Network.EnableIPv6 = false` in iwd; keys are case-sensitive)                              |
| Config        | `hosts/corbelan/configuration.nix`                                          |

Saved networks: `/var/lib/iwd/*.psk` (root-only). Per-network options like `AutoConnect` go in those files, not `main.conf`.

MAC randomization is off (iwd default `AddressRandomization = disabled`). Keep it that way: AdGuard Home identifies Corbelan by its permanent MAC (`data/hosts.nix`).

WiFi chip: MediaTek MT7925 (`mt7925e`). iwd access needs root or `wheel`.

**Why no NetworkManager:** NM's iwd backend mirrors iwd known networks as in-memory NM profiles and calls iwd's `Forget` when those profiles go away. With Impala managing iwd directly, failed connects led to saved networks vanishing. Running iwd alone removes the sync layer.

```bash
impala                          # manage WiFi
iwctl station wlan0 show        # connection state
iwctl known-networks list       # saved networks
journalctl -u iwd -b            # logs
```

## Nostromo (Desktop)

| Layer        | Config                                                          |
| ------------ | --------------------------------------------------------------- |
| Link manager | **NetworkManager** (default wpa_supplicant backend, wired use)  |
| UI           | `nmtui`; Waybar network module click opens it                   |
| Addressing   | NM internal DHCP client (lease from AGH on Sulaco)              |
| DNS          | NM writes DHCP-provided DNS (Sulaco/AGH) via `resolvconf`       |
| Config       | `hosts/nostromo/configuration.nix` (`networking.networkmanager.enable`) |

User `gray` is in the `networkmanager` group (`modules/nixos/core/user.nix`, only when NM enabled).

```bash
nmcli device status
nmcli connection show
journalctl -u NetworkManager -b
```

## Sulaco (Server)

| Layer        | Config                                                                     |
| ------------ | -------------------------------------------------------------------------- |
| Link manager | NixOS scripted networking (no NM, no networkd)                             |
| Addressing   | Static `192.168.86.2/24` on `enp2s0` (`host.staticIP`, `host.networkInterface`); `useDHCP = false` |
| Gateway      | `192.168.86.1` (`constants.network.gateway`)                               |
| DNS          | Nameservers: `192.168.86.1` (from `networking.nix`) + `127.0.0.1` (from `adguardhome.nix`), merged in that order |
| LAN services | AdGuard Home: DNS (53) and DHCP (67/68) on `enp2s0`                        |
| Ingress      | Caddy on 80/443, TLS via Cloudflare DNS-01, `*.lab.ggantek.net`            |
| Firewall     | PostgreSQL only on `docker0`; DNS/DHCP only on `enp2s0`; game/service ports per [sulaco.md](./sulaco.md) |
| Config       | `hosts/sulaco/configuration.nix`, static block in `modules/nixos/network/networking.nix`, `modules/nixos/services/{adguardhome,caddy}.nix` |

Full port map: [sulaco.md](./sulaco.md).

```bash
ip addr show enp2s0
cat /etc/resolv.conf
journalctl -u adguardhome -b
```
