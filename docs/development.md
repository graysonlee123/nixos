# Development

## PHP (WordPress)

PHP 8.2, Composer, and wp-cli are via Nix. `phpcs`/`phpcbf` and WPCS are via Composer global (`~/.config/composer/vendor/bin` is on `PATH`).

**First-time setup:**
```bash
composer global require wp-coding-standards/wpcs dealerdirect/phpcodesniffer-composer-installer
```

**Usage:**
```bash
phpcs --standard=WordPress file.php   # check
phpcbf --standard=WordPress file.php  # fix
```

Add `phpcs.xml` to a project root to avoid repeating `--standard=WordPress` and to exclude `vendor/` etc., then run `phpcs .`:

```xml
<?xml version="1.0"?>
<ruleset>
    <rule ref="WordPress"/>
    <exclude-pattern>vendor/</exclude-pattern>
    <exclude-pattern>node_modules/</exclude-pattern>
</ruleset>
```

## XDG MIME Defaults

Default applications are configured in `modules/home-manager/xdg.nix` via `xdg.mimeApps.defaultApplications`. Note that XDG MIME wildcards (e.g. `video/*`) don't work in `mimeapps.list` — each MIME type must be listed explicitly.

However, many associations happen automatically without explicit configuration. Apps like VLC declare supported MIME types in their `.desktop` files, which get indexed into `mimeinfo.cache`. The XDG lookup chain is:

1. **`mimeapps.list`** (explicit defaults from xdg.nix)
2. **`mimeinfo.cache`** (built from installed apps' `.desktop` files)

So explicit entries in xdg.nix are only needed when you want to *override* what installed apps already claim. For example, VLC already advertises support for most media types, so it wins by default without any xdg.nix entry.

### XDG Desktop Portals

XDG desktop portals provide sandboxed apps (Flatpaks, Electron apps) controlled access to system resources on Wayland. Configured in `modules/nixos/xdg.nix` using `xdg-desktop-portal-wlr` for Sway. Enables:

- File picker dialogs in browsers and apps
- Screen sharing/recording in web apps
- Screenshot capabilities across sandbox boundaries
