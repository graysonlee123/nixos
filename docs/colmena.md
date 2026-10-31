# Colmena

[Colmena](https://github.com/nix-community/colmena) deploys NixOS configurations to remote hosts over SSH. In this repo it pushes to Sulaco from a headed host. Nostromo and Corbelan are still rebuilt locally with `nixos-rebuild`.

## How it's wired

All hosts are defined once, as nodes in the `colmenaHive` output of `flake.nix` (built with `colmena.lib.makeHive`). `nixosConfigurations` is derived from the hive:

```nix
nixosConfigurations = self.colmenaHive.nodes;
```

The same definitions serve both tools, so `nixos-rebuild --flake .` and `colmena` always build identical systems.

### Deployment targets

| Host     | `targetHost` | Deployed by                 |
| -------- | ------------ | --------------------------- |
| Sulaco   | `"sulaco"`   | `colmena apply`             |
| Nostromo | `null`       | `sudo nixos-rebuild switch` |
| Corbelan | `null`       | `sudo nixos-rebuild switch` |

A `null` `targetHost` makes `colmena apply` skip the node but still build it, so `colmena build` checks all three hosts.

### Target host requirements

Colmena connects as `gray`, not root. `modules/nixos/core/deploy-target.nix` (imported by `profiles/headless.nix`) sets:

- `nix.settings.trusted-users = ["gray"]`: lets the closure push succeed. Without it, Sulaco rejects locally built paths with `lacks a signature by a trusted key`.
- `security.sudo.wheelNeedsPassword = false`: activation runs through non-interactive `sudo`, which can't prompt for a password.

Both settings make `gray` effectively root on Sulaco. `gray` already has sudo there, so this adds little real exposure.

**Bootstrap:** a fresh headless host has to get these settings before Colmena can deploy to it, because the push is the step that fails without them. Apply them once on the host itself:

```sh
sudo nixos-rebuild switch --flake .
```

## Usage

Run from the repo root on a headed host:

```sh
colmena apply                   # deploy all nodes with a targetHost (Sulaco)
colmena apply --on sulaco       # deploy one node
colmena build                   # build every node, deploy nothing
colmena apply dry-activate      # push and show what would change
colmena apply boot              # activate on next boot
```

Colmena builds on the deploying machine by default, then copies the closure to the target.

### Dirty git tree

With uncommitted changes, Colmena fails with:

```
error: cannot update unlocked flake input 'hive' in pure mode
```

Colmena evaluates through a generated wrapper flake that points at this repo's locked URL. A dirty tree has no `rev`, so that URL is unlocked, and pure evaluation refuses it. Either commit or stash first, or pass `--impure` while iterating:

```sh
colmena apply --on sulaco --impure
```

As with any flake, new files must be `git add`ed before Nix can see them.

## Troubleshooting

| Error                                                    | Cause                                                        |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| `Permission denied (publickey,...)`                      | `targetHost` is an IP, so the SSH config alias isn't matched |
| `lacks a signature by a trusted key`                     | `gray` isn't in `trusted-users` on the target                |
| `cannot update unlocked flake input 'hive' in pure mode` | Dirty git tree; commit or pass `--impure`                    |
