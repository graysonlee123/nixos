# Audio

PipeWire with ALSA and PulseAudio compatibility layers (`modules/nixos/audio.nix`):

- **PipeWire**: The primary audio server, replacing the older PulseAudio and JACK servers. Handles routing audio between apps and hardware devices.
- **ALSA compat** (`alsa.enable`): Exposes a virtual ALSA device backed by PipeWire, so apps that use ALSA directly (instead of PulseAudio) still work.
- **PulseAudio compat** (`pulse.enable`): Runs a PulseAudio socket emulator so apps built against the PulseAudio API work without modification.
- **rtkit**: Grants PipeWire real-time scheduling priority, reducing audio latency and preventing dropouts under CPU load.

**Hardware mic gain (e.g. Samson Q9U):** The OS volume slider controls PipeWire's software gain — it doesn't affect the hardware capture level. If your mic is quiet even at 100%, the hardware gain may be set low. Check it via `alsamixer`, press `F6` to select the physical device, then `F4` for capture controls.
