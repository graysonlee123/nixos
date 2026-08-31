# Vesktop Screenshare

## Issue

Screensharing stops working after clicking "Update" in Vesktop's update prompt. Symptom: slurp output picker appears, output selected, nothing happens.

## Cause

Vesktop downloads Vencord updates to `~/.config/vesktop/sessionData/vencordFiles/`, overriding the Nix-managed version. A Vencord update broke the screenshare flow.

## Fix

Delete the downloaded Vencord files so Vesktop falls back to the bundled nix store version:

```bash
rm ~/.config/vesktop/sessionData/vencordFiles/vencordDesktop*.js*
rm ~/.config/vesktop/sessionData/vencordFiles/vencordDesktop*.css*
```

Restart Vesktop.

## Prevention

`checkUpdates = false` in `modules/home/apps/vesktop.nix` disables update notifications so the prompt doesn't appear.

## Issue: no sources after nixpkgs 25.11 → 26.05 bump

Symptom: screenshare picker fails immediately. Logs:

```
xdg-desktop-portal-wlr: [ERROR] - wlroots: no output found
/bin/sh: line 1: wofi: command not found   (also fuzzel, bemenu)
ScreenCastPortal failed: 3
```

(The `--ozone-platform=wayland is not compatible with Vulkan` warning is unrelated/benign.)

### Cause

Bump moved `xdg-desktop-portal-wlr` 0.7.x → 0.8.0, which changed the default
output chooser. On a multi-output host (Nostromo: DP-1 + HDMI-A-1) the portal
must ask which output to capture. With no chooser configured it falls back to
searching for dmenu-style pickers (`wofi`/`fuzzel`/`bemenu`) — none installed —
then gives up with `no output found`. Single-output hosts auto-select and never
hit this.

### Fix

Configure the wlr portal chooser to use `slurp` (already installed) in
`modules/nixos/core/xdg.nix`:

```nix
xdg.portal.wlr.settings.screencast = {
  chooser_type = "simple";
  chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  max_fps = 60;
};
```

Apply, then restart the portals:

```bash
sudo nixos-rebuild switch --flake .
systemctl --user restart xdg-desktop-portal-wlr.service xdg-desktop-portal.service
```

Sharing now prompts via slurp — click a monitor to select it.

### Notes

- `chooser_cmd` stdout must be **only** the exact output name (per
  `wayland-info`). `-f %o` prints `HDMI-A-1`; anything else (e.g. a
  `-f 'Monitor: %o'` prefix, as in the NixOS option docs) is treated as
  "declined" and silently fails. `-o` = whole-output boxes, `-r` = snap to them.
- To pin one fixed monitor with no picker instead: `chooser_type = "none";`
  plus `output_name = "DP-1";`.
