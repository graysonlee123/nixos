# Git Configuration

Git is configured with conditional includes that automatically switch email addresses based on repository location:

- **Default**: `github@graysn.com` for personal projects
- **Work**: `grayson@inspry.com` for repositories in `~/repos/inspry/`

## Multiple GitHub Accounts with SSH

The configuration handles multiple GitHub accounts (personal + work) using SSH config aliases combined with Git URL rewriting:

**How it works:**

1. **SSH Config** (`modules/home-manager/ssh.nix`):
   - `github.com` → personal key (`~/.ssh/github`)
   - `inspry.github.com` → work key (`~/.ssh/github-inspry`)

2. **Git URL Rewriting** (`modules/home-manager/git.nix`):
   - In `~/repos/inspry/`: Git auto-rewrites `git@github.com:inspry/` → `git@inspry.github.com:inspry/`
   - SSH config then routes to work key

3. **Result**: Use standard GitHub URLs everywhere. In work dir, URLs auto-rewrite to use work key.

**Benefits:**
- No manual URL editing for work repos
- Submodules work seamlessly (before, this was a big issue)
- Clone with standard URLs: `git clone git@github.com:inspry/repo`
- Git handles URL rewriting transparently
