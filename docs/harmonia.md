# Harmonia Binary Cache

Every NixOS host runs [Harmonia](https://github.com/nix-community/harmonia) and serves its `/nix/store` to the other hosts over Tailscale. A path that one host has already built or downloaded is copied from that host instead of being rebuilt or fetched from `cache.nixos.org`. For Harmonia setup and options, see the upstream README.

Module: `modules/nixos/services/harmonia.nix` (imported by `profiles/base.nix`).

## How it works

- **Port**: `5839/TCP`, opened on `tailscale0` only. Nothing is exposed on the LAN or WAN.
- **Peers**: every host in `data/lan.nix` with `isNixOS = true` and a `harmoniaPubKey`, except the current host. Peers are reached by their Tailscale IP.
- **Signing**: each host signs the paths it serves with its own key (`<host>-harmonia-1`). Peers trust only the public keys in `data/lan.nix`. The private key lives in `secrets/hosts/<host>.yaml`, and only that host can decrypt it (see [sops.md](./sops.md)).
- **Priority** (lower wins): Sulaco `10`, Nostromo `20`, Corbelan `30`, `cache.nixos.org` `40`. Set in the `priorities` map in the module. Hosts not in the map get `35`.
- **Offline peers**: `connect-timeout = 3` and `fallback = true`. An offline peer (e.g. a sleeping laptop) costs about 3s per rebuild, and then Nix moves on to the next substituter.

## Add a host

1. In `data/lan.nix`, set `isNixOS = true` and `ips.tailscale` for the host.
2. Add a `secrets/hosts/<host>.yaml` rule to `.sops.yaml`, using only that host's age key.
3. Generate the signing key and encrypt it. This works from any host, because encryption only needs public keys:

   ```sh
   h=<host>; tmp=$(mktemp -d)
   nix-store --generate-binary-cache-key "$h-harmonia-1" $tmp/sk $tmp/pk
   printf 'harmonia:\n    sign-key: %s\n' "$(cat $tmp/sk)" > $tmp/$h.yaml
   sops encrypt --filename-override secrets/hosts/$h.yaml --input-type yaml --output-type yaml $tmp/$h.yaml > secrets/hosts/$h.yaml
   cat $tmp/pk; shred -u $tmp/*; rmdir $tmp
   ```

4. Put the printed public key in `harmoniaPubKey` for the host in `data/lan.nix`.
5. Optional: add the host to the `priorities` map in the module.
6. Rebuild the new host and every peer, so that the peers trust the new key.

To rotate a key, repeat steps 3 and 4 with a new name (e.g. `<host>-harmonia-2`), then rebuild all hosts.

## Health checks

Run these from any peer. Replace `<ip>` with the target host's Tailscale IP from `data/lan.nix`.

```sh
# Service is running (on the target host)
systemctl status harmonia.service harmonia.socket
journalctl -u harmonia -n 50

# Cache is reachable (expect "StoreDir: /nix/store")
curl -m 5 http://<ip>:5839/nix-cache-info

# This host's substituters and trusted keys
grep -E '^(substituters|trusted-public-keys)' /etc/nix/nix.conf

# A path's narinfo is signed by the target host's key (expect "Sig: <host>-harmonia-1:...")
p=$(readlink -f /run/current-system/sw/bin/bash | cut -d/ -f1-4)
curl -s http://<ip>:5839/$(basename $p | cut -c1-32).narinfo | grep '^Sig'

# The signature verifies against the expected public key
nix store verify --no-contents --store http://<ip>:5839 \
  --trusted-public-keys '<host>-harmonia-1:<pubkey>' $p

# Rebuild actually pulls from peers (look for "copying path ... from 'http://100.x.x.x:5839'")
sudo nixos-rebuild switch --flake . -v 2>&1 | grep "from 'http://100"
```

### End-to-end test

Add a unique path on the target host, then fetch it from another host:

```sh
# On the target host: prints a /nix/store/... path
f=$(mktemp); echo "harmonia-test-$(date +%s)" > $f; nix-store --add $f

# On another host: should print "copying path ... from 'http://<ip>:5839'"
nix-store -r <printed path> -v

# Clean up on both hosts
nix-store --delete <printed path>
```

## Troubleshooting

| Symptom                                 | Cause                                                                                                     |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `Connection timed out after 3000 milliseconds` | Peer is offline, or Tailscale is down on one side. Harmless thanks to `fallback`.                  |
| SSL or redirect error                   | Substituter URL is missing `:5839`, so the request hits Caddy on port 80.                                 |
| `path ... is untrusted`                 | The peer signs with a key that this host doesn't trust. Usually one side hasn't rebuilt since a key change. |
| `Connection refused`                    | Harmonia isn't running on the peer, or `tailscale0` doesn't have 5839 open in the firewall.               |
