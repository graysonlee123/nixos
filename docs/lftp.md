# lftp Configuration

Configured in `modules/home-manager/lftp.nix`.

## Bookmarks

Bookmarks are symlinked from Syncthing (`~/syncthing/lftp/bookmarks`) via `mkOutOfStoreSymlink`. This avoids committing a high-churn file to git -- bookmark changes sync across machines via Syncthing instead.

## RC Settings

- `cmd:default-protocol sftp` -- default to SFTP when no protocol specified
- `cmd:ls-default -l` -- long listing by default
- `cmd:prompt` -- custom multi-line prompt showing host, working dir, and version

## SSL Verification

SSL certificate verification is **enabled** (lftp default). For hosts with self-signed or untrusted certs, use the `lftpi` shell alias:

```sh
lftpi <host>
```

This runs `lftp -e 'set ssl:verify-certificate no'`, scoped to that session only. Regular `lftp` connections remain verified.
