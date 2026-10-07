# Garbage Collection

Automatic Nix store cleanup on all hosts, configured in `profiles/base.nix` via `nix.gc`.

## How it works

- **Schedule**: `daily` (midnight), via the `nix-gc.timer` systemd timer
- **Retention**: `--delete-older-than 14d`. Deletes system generations older than 14 days, then garbage-collects store paths that are no longer referenced.
- **Persistent**: if the machine is off at midnight, the run happens at next boot

Rollback targets only go back 14 days. A host that hasn't been rebuilt in a while can end up with just its current generation.

## Checking it

```sh
systemctl list-timers nix-gc        # next/last run
systemctl status nix-gc.service     # last run result
journalctl -u nix-gc.service        # GC output (paths deleted, space freed)
```

## Running manually

```sh
sudo systemctl start nix-gc.service           # same as the scheduled run
sudo nix-collect-garbage --delete-older-than 14d
sudo nix-collect-garbage -d                   # deletes ALL old generations, no rollback
```
