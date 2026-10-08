# Audio

PipeWire with ALSA and PulseAudio compatibility layers (`modules/nixos/hardware/audio.nix`):

- **PipeWire**: The primary audio server, replacing the older PulseAudio and JACK servers. Handles routing audio between apps and hardware devices.
- **ALSA compat** (`alsa.enable`): Exposes a virtual ALSA device backed by PipeWire, so apps that use ALSA directly (instead of PulseAudio) still work.
- **PulseAudio compat** (`pulse.enable`): Runs a PulseAudio socket emulator so apps built against the PulseAudio API work without modification.
- **JACK compat** (`jack.enable`): Lets apps built against the JACK API run on PipeWire.
- **rtkit**: Grants PipeWire real-time scheduling priority, reducing audio latency and preventing dropouts under CPU load.

**Hardware mic gain (e.g. Samson Q9U):** The OS volume slider controls PipeWire's software gain — it doesn't affect the hardware capture level. If your mic is quiet even at 100%, the hardware gain may be set low. Check it via `alsamixer`, press `F6` to select the physical device, then `F4` for capture controls.

On Nostromo this is handled automatically:

- `modules/nixos/hardware/samson-q9u-gain.nix`: a systemd timer (every 2 min) restores the Q9U "Mic Gain" to raw 51 (12 dB) whenever it drops below that, e.g. after a reconnect. Check with `systemctl list-timers restore-mic-gain`.
- Waybar `custom/mic-gain` module shows the current hardware gain in dB; click it to open `alsamixer`.
