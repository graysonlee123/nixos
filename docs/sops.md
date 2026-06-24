# sops-nix Secrets Management

Encrypts secrets with age public keys, commits encrypted files to git, decrypts at boot using machine's private key. Secrets land in `/run/secrets/` (tmpfs, RAM-only). Nested YAML keys become path segments (e.g. `/run/secrets/gameservers/terraria/worldname/password`). Templates allow creating env-like files in `/run/secrets/rendered`.

## Setup

1. **Age keypair** -- `age-keygen -o ~/.config/sops/age/keys.txt`. Private key stays on machine, never committed. Public key goes in `.sops.yaml`.
2. **`.sops.yaml`** -- Defines which age public keys to encrypt with. Multiple keys = multiple machines can decrypt same file. See repo root.
3. **NixOS module** (`modules/nixos/sops.nix`) -- Declares which secrets to decrypt at boot. Each entry becomes a file under `/run/secrets/` (root:root 0400 by default).

## Operations

| Task                       | Command                                                                  |
| -------------------------- | ------------------------------------------------------------------------ |
| Encrypt new file           | `sops --encrypt --in-place secrets/secrets.yaml`                         |
| Edit encrypted file        | `sops secrets/secrets.yaml` (decrypts in `$EDITOR`, re-encrypts on save) |
| Read secret                | `sudo cat /run/secrets/<path>`                                           |
| Re-encrypt for new machine | `sops updatekeys secrets/secrets.yaml`                                   |

### Add a machine

1. Generate age keypair on new machine
2. Add public key to `.sops.yaml`
3. Re-encrypt: `sops updatekeys secrets/secrets.yaml`

### Set permissions / use in a service

```nix
sops.secrets."my/secret" = { owner = "gray"; };
services.something.environmentFile = config.sops.secrets."my/secret".path;
```
