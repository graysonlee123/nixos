# The Samson Q9U's hardware "Mic Gain" control drops (often to ~40%) when the
# mic reconnects due to a faulty cable, or when an app rewrites it. A timer
# restores it to `target` (raw value in the control's 0-59 range) whenever it
# has dropped below. ALSA hardware controls are global, so this runs as a
# system service rather than per-user.
{pkgs, ...}: let
  card = "Q9U";
  control = "Mic Gain";
  target = 51; # raw; dB gain = raw - 39
  # Read raw gain:   amixer -c Q9U sget 'Mic Gain'
  # Simulate drop:   amixer -c Q9U sset 'Mic Gain' 20   (below target)
  # Guard check:     amixer -c Q9U sset 'Mic Gain' 55   (above target; stays)
  restore = pkgs.writeShellScript "restore-mic-gain" ''
    current=$(${pkgs.alsa-utils}/bin/amixer -c ${card} sget "${control}" \
      | ${pkgs.gawk}/bin/awk '/Mono:.*Capture/{print $3; exit}')
    if [ -n "$current" ] && [ "$current" -lt ${toString target} ]; then
      ${pkgs.alsa-utils}/bin/amixer -c ${card} sset "${control}" ${toString target}
    fi
  '';
in {
  # Inspect:   systemctl cat restore-mic-gain.service
  # Run now:   sudo systemctl start restore-mic-gain.service
  # Logs:      journalctl -u restore-mic-gain.service -n 20 --no-pager
  systemd.services.restore-mic-gain = {
    description = "Restore Samson Q9U mic gain";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${restore}";
    };
  };

  # Timer status:   systemctl list-timers restore-mic-gain
  systemd.timers.restore-mic-gain = {
    description = "Periodically restore Samson Q9U mic gain";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "10sec";
      OnUnitActiveSec = "2min";
    };
  };
}
