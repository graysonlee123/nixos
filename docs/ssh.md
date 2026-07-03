# SSH Configuration

User SSH Configuration file (`~/.ssh/config`) is managed by `modules/home-manager/ssh.nix`.

- Each entry in `users/gray.nix` requires a private key defined in `secrets/headed.yaml` under `ssh/keys/<entry_name>`.
- Public keys are not sensitive and therefore defined inline.
- Private keys are decrypted by sops-nix at activation and placed into `~/.ssh/` (see `modules/home-manager/sops.nix`).

## Host blocks

**`github.com`**:

Personal GitHub authentication.

**`sulaco`, `sulaco.local`**:

Used to SSH/SFTP into Sulaco. Use `sulaco` for TailScale path, `sulaco.local` for LAN.

**`*.pressable.com`**:

Used to SSH/SFTP into a website under the Inspry account.

```shell
ssh <site_username>@ssh.pressable.com
lftp sftp://<site_username>@ssh.pressable.com
```

**`*.ssh.wpengine.net`**:

SSH only (no SFTP) for an environment.

```shell
ssh <environment>@<environment>.ssh.wpengine.net
```

**`bigscoots`**:

SSH/SFTP into BigScoots server (contains all websites).

```shell
ssh bigscoots
lftp sftp://bigscoots
```

**`bitbucket.org`**:

Authenticate into BitBucket repositories.

**`inspry.github.com`**:

Used for multi-account authentication (see [git.md](./git.md) for details).

**`rocket.net`**:

Rims Outlet sites on Rocket.net.

```shell
ssh <username>@rocket.net
lftp sftp://<username>@rocket.net
```

**`ssh.dev.azure.com`**:

Authenticate into Azure repositories.
