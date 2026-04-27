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

`checkUpdates = false` in `modules/home-manager/vesktop.nix` disables update notifications so the prompt doesn't appear.
