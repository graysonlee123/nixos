# Vesktop

Configured in `modules/home/apps/vesktop.nix`. Screenshare issues: see [vesktop-screenshare.md](vesktop-screenshare.md).

## Issue: white screen on launch

Window opens, stays blank white. No errors in `journalctl --user`; launching from a terminal shows only `EROFS` noise (see Notes).

### Cause

Stale Vencord build in `~/.config/vesktop/sessionData/vencordFiles/` (files dated months old). Vesktop loads these downloaded files over the Nix-bundled Vencord; an old build no longer works with current Discord and the renderer never draws.

Ruled out while debugging:

- GPU: `vesktop --disable-gpu` still white
- Chromium caches (`Cache`, `Code Cache`, `GPUCache`, `Dawn*`, `Service Worker`)
- Storage (`Local Storage`, `IndexedDB`, `Session Storage`, `blob_storage`)
- Read-only Home Manager settings files

### Fix

Quit Vesktop, move the downloaded files aside, relaunch. Vesktop fetches a fresh build; login is kept.

```bash
mv ~/.config/vesktop/sessionData/vencordFiles ~/.cache/vencordFiles.bak
vesktop
```

Delete the backup once it works.

### Debugging tips

- Test against a throwaway profile without touching the real one:
  ```bash
  cp -aL ~/.config/vesktop /tmp/vtest
  VENCORD_USER_DATA_DIR=/tmp/vtest vesktop
  ```
  Remove dirs from `/tmp/vtest` to bisect. A fully empty `VENCORD_USER_DATA_DIR` that renders confirms the problem is profile state.
- Kill Vesktop with `pkill -f '[v]esktop-1.6.5'` (bracket stops the pattern matching the calling shell).

### Notes

- `autoUpdate = true` (Vencord) didn't replace the stale build on its own; reason unknown.
- `Failed to write renderer settings Error: EROFS ... settings/settings.json` repeats in the log. Vencord tries to write its settings, which Home Manager links read-only from the store. Harmless.
