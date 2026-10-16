# MangoHud

Performance overlay (FPS, frame times, CPU/GPU stats) for Vulkan and OpenGL games. Configured in `modules/home/apps/mangohud.nix`, imported by the headed HM profile (Corbelan, Nostromo). Stylix themes colors and font; overall and background alpha are overridden (0.9 and 0.6).

## Launching

| Context | Command |
|---------|---------|
| Any game | `mangohud <command>` |
| Steam launch option | `mangohud %command%` |
| OpenGL game with no overlay | `mangohud --dlsym <command>` |
| Inside gamescope | `gamescope --mangoapp -- %command%` (not `mangohud`) |
| Quick test (Vulkan) | `nix shell nixpkgs#vulkan-tools -c mangohud vkcube` |
| Quick test (OpenGL) | `nix shell nixpkgs#mesa-demos -c mangohud glxgears` |

The HUD shows on launch.

## Hotkeys

| Keys | Action |
|------|--------|
| `Shift_R+F12` | Toggle HUD |
| `Shift_R+F11` | Cycle HUD position |
| `Shift_R+F10` | Cycle presets |
| `Shift_L+F1` | Cycle FPS limit (unlimited, 60, 120, 180) |
| `Shift_L+F2` | Start/stop logging |
| `Shift_L+F4` | Reload config |
| `Shift_R+F9` | Reset FPS metrics (avg, 1% and 0.1% lows) |

## FPS limits

MangoHud enforces the cap itself, so it works for games without a built-in limiter. Useful for reducing heat/fan noise, saving battery on Corbelan, or getting steadier frame pacing. Limits start at unlimited (`0`). The 180 option matches Nostromo's LG UltraGear (DP-1, 180 Hz).

## Displayed stats

Current FPS, session average with 1% and 0.1% lows, active FPS limit, resolution, frame time graph, GPU load/temp/power/VRAM, CPU load/temp, RAM, GameMode status, Wine/Proton version. Battery is shown on Corbelan only (`battery = isLaptop`).

## Logging

`Shift_L+F2` writes a CSV of FPS and frame times. Upload it to [flightlessmango.com](https://flightlessmango.com/logs/new) to graph it, or compare runs.

## Overrides

- One-off: `MANGOHUD_CONFIG="fps,position=top-right" mangohud <command>`
- Per game: add an entry to `programs.mangohud.settingsPerApplication` keyed by executable name.
- Full option list: `man mangohud` or the [MangoHud README](https://github.com/flightlessmango/MangoHud#hud-configuration).

## Example config (all options)

The man page points to `/usr/share/doc/mangohud/MangoHud.conf`. On NixOS it lives in the package's separate `doc` output instead:

```sh
nix build --no-link --print-out-paths nixpkgs#mangohud.doc
# then open <path>/share/doc/mangohud/MangoHud.conf.example
```
