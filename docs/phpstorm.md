# PhpStorm

## Syncing deployment/SSH/web-server configs across machines

Deployment servers, SSH, and web servers are per-project (`.idea/`) because "Visible only for this project" is checked. Uncheck it → they move to IDE level (`options/{webServers,sshConfigs}.xml`) and **Settings Sync** (JBA account, already on) replicates them to the other machine.

- These three files hold **no secrets**: SSH auth rides `~/.ssh/config` + agent. (`workspace.xml`/DB `dataSources` can hold secrets — never sync those.)
- Staging hosts/roots are host-assigned, not derivable from the domain, so they must be stored, not generated.

**Fix** — two levels, both must be made global:

1. Settings → Build, Execution, Deployment → **Deployment** → uncheck "Visible only for this project" per server.
2. Settings → Tools → **SSH Configurations** → uncheck "Visible only for this project" per config.

Leave both unchecked for new ones. Ensure Settings Sync includes the **Tools** category.

Stays per-project: `deployment.xml` (default server + `/`↔`$PROJECT_DIR$` mapping) — pick the now-global server once per project on machine 2. Trade-off: one global server dropdown for all sites.

## Search Everywhere (Shift+Shift) popup opens off-screen on Sway

### Symptom

Pressing Shift+Shift (Search Everywhere) does nothing visible, but PhpStorm behaves as if the popup is open: the editor loses focus and keystrokes don't land in it. Other UI like Settings opens fine. The popup is actually rendering far off-screen and can't be dragged back.

### Cause

PhpStorm runs under XWayland. Lightweight popups (Search Everywhere, completion, menus) are created as X11 **override-redirect** surfaces, which are unmanaged — the compositor doesn't place or decorate them (this is also why `swaymsg -t get_tree` never lists them, working or not, and why the popup can't be dragged).

Under wlroots/Sway, JetBrains' global-coordinate placement math for these surfaces is wrong (aggravated by multi-monitor + HiDPI, note the `--force-device-scale-factor=1.0` in the process args), so the popup maps at bad coordinates far off the visible output. "Normal" windows like Settings are managed by Sway and placed correctly, so they work.

### Fix

Run PhpStorm with the native Wayland toolkit (JBR 21 in 2025.3+ supports it). Popups become real Wayland subsurfaces anchored to the parent window, so the broken XWayland placement path is bypassed entirely.

`Help → Edit Custom VM Options`, add:

```
-Dawt.toolkit.name=WLToolkit
```

Restart PhpStorm.

### Things that did NOT fix it

- Resetting/deleting window position state (`window.state.xml`)
- `_JAVA_AWT_WM_NONREPARENTING=1`
- Other X11-side popup tweaks

These don't help because the popup is a mis-placed override-redirect X11 surface, not a hidden/blank render — only switching off the XWayland surface path resolves it.
