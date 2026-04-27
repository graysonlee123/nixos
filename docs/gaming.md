# Gaming

## Minecraft (via Prism Launcher)

Prism Launcher is installed via nixpkgs and has much better overall compatibility than ATLauncher.

### Streaming audio via Vesktop

Minecraft runs on the JVM, so its PipeWire audio stream is registered as `java` with no application name. Vesktop filters unnamed streams and won't show it as an audio source.

Fix: in the Prism Launcher instance settings, add this environment variable:

```
PIPEWIRE_PROPS=application.name=Minecraft
```

After relaunching, Minecraft will appear as "Minecraft" in Vesktop's audio source picker.

### Mic cuts out when streaming

Vesktop auto-switches input/output devices when a new audio source appears (e.g. the Minecraft stream). Fix: set input and output devices explicitly in Vesktop's Voice & Video settings instead of using "Default".

## Gamescope (Steam Game Scaling)

Gamescope is a micro-compositor for scaling games. Key flags:

- `-w` / `-h` — game (inner) resolution
- `-W` / `-H` — output (display) resolution
- `-S` / `--scaler` — scaling mode: `auto`, `integer`, `fit`, `fill`, `stretch`
- `-F` / `--filter` — upscale filter: `linear`, `nearest`, `fsr`, `nis`, `pixel`

### Corbelan (2880x1800)

For integer scaling, the game resolution must divide evenly into the output resolution. Common clean ratios for 1800p:

| Game height | Scale factor | Notes |
|-------------|-------------|-------|
| 900 | 2x | Good default for most games |
| 600 | 3x | Ideal for old 800x600 games |
| 450 | 4x | Very low res |

General template:
```
gamescope -w <game_w> -h <game_h> -W 2880 -H 1800 -S integer -F nearest --fullscreen -- %command%
```

If integer scaling doesn't work (game res doesn't divide evenly), use `fit` + `fsr`:
```
gamescope -w <game_w> -h <game_h> -W 2880 -H 1800 -S fit -F fsr --fullscreen -- %command%
```

### Peggle Deluxe (800x600)

Native 800x600 → 3x integer to 1800p. Uses `PROTON_USE_WINED3D=1` to fix game speed issues caused by Proton's DXVK timing with old DirectX games.

```
PROTON_USE_WINED3D=1 gamescope -w 800 -h 600 -W 2880 -H 1800 --scaler integer --filter nearest --fullscreen -- %command%
```
