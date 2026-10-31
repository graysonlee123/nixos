{
  config,
  isLaptop,
  lib,
  pkgs,
  ...
}: let
  replayDir = "%h/Videos/Replays";
  recordingDir = "%h/Videos/Recordings";
  unit = "gpu-screen-recorder-replay";
  # App name lets mako route these to a visible output (see below).
  notify = "${pkgs.libnotify}/bin/notify-send -a gsr";
  # Marks a regular recording in progress; gsr doesn't report start itself.
  recordingFlag = "$XDG_RUNTIME_DIR/gsr-recording";
  # Waybar indicator refresh; mullvad uses 11, mouse battery 12. Only sent
  # from keybind/save paths, never at login: an RTMIN before waybar installs
  # its handlers kills it. The 1s poll covers service starts and crashes.
  waybarSignal = 13;
  refreshWaybar = "${pkgs.procps}/bin/pkill -RTMIN+${toString waybarSignal} waybar || true";
  waybarStatus = pkgs.writeShellScript "waybar-gsr" ''
    if [ -e "${recordingFlag}" ]; then
      # Alternate class each second for a blink; GTK CSS animations don't
      # tick in waybar.
      if (( $(date +%s) % 2 )); then cls=recording; else cls=recording-dim; fi
      echo '{"text": "󰑊 REC", "class": "'"$cls"'", "tooltip": "Recording (Mod+x to stop)"}'
    elif systemctl --user is-active -q ${unit}; then
      echo '{"text": " 󰕧 ", "class": "replay", "tooltip": "Replay buffer on (Mod+z to save)"}'
    else
      echo '{"text": ""}'
    fi
  '';
  # Called by gsr after each save with file path ($1) and type ($2).
  onSave = pkgs.writeShellScript "gsr-on-save" ''
    case "$2" in
      regular)
        rm -f "${recordingFlag}"
        ${refreshWaybar}
        ${notify} "Recording saved" "$1" ;;
      *)
        ${notify} "Replay saved" "$1" ;;
    esac
  '';
  # SIGUSR1 to main PID only: pkill -f also hit gsr-kms-server (killing capture).
  save = pkgs.writeShellScript "gsr-save" ''
    systemctl --user kill -s SIGUSR1 --kill-whom=main ${unit} \
      || ${notify} "Replay buffer not running"
  '';
  # SIGRTMIN starts/stops a regular recording alongside the replay buffer.
  record = pkgs.writeShellScript "gsr-record" ''
    if ! systemctl --user kill -s SIGRTMIN --kill-whom=main ${unit}; then
      ${notify} "Replay buffer not running"
    elif [ -e "${recordingFlag}" ]; then
      rm -f "${recordingFlag}"
      ${refreshWaybar}
    else
      touch "${recordingFlag}"
      ${refreshWaybar}
      ${notify} "Recording started"
    fi
  '';
  toggle = pkgs.writeShellScript "gsr-toggle" ''
    # Drop presses while a toggle is in flight; they used to queue up behind
    # a slow stop and all fire at once.
    exec 9>"$XDG_RUNTIME_DIR/gsr-toggle.lock"
    ${pkgs.util-linux}/bin/flock -n 9 || exit 0

    if systemctl --user is-active -q ${unit}; then
      systemctl --user stop ${unit}
      ${refreshWaybar}
      ${notify} "Replay buffer stopped"
    else
      systemctl --user reset-failed ${unit} 2>/dev/null
      systemctl --user start ${unit}
      # gsr fails a moment after launch (e.g. no kms), so check before notifying.
      sleep 1
      ${refreshWaybar}
      if systemctl --user is-active -q ${unit}; then
        ${notify} "Replay buffer started"
      else
        ${notify} -u critical "Replay buffer failed" "journalctl --user -u ${unit}"
      fi
    fi
  '';
in {
  # Replay buffer: keeps last 60s in RAM, Mod+z dumps to disk.
  # Mod+x starts/stops a regular recording on the same capture.
  # Auto-starts on desktop only; laptop toggles manually to save battery.
  systemd.user.services.${unit} = {
    Unit = {
      Description = "GPU Screen Recorder replay buffer";
      PartOf = ["sway-session.target"];
      After = ["sway-session.target"];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${replayDir} ${recordingDir}";
      # Fresh process has no recording running.
      ExecStopPost = "${pkgs.coreutils}/bin/rm -f %t/gsr-recording";
      ExecStart = lib.concatStringsSep " " [
        "${lib.getExe pkgs.gpu-screen-recorder}"
        "-w ${
          if isLaptop
          then "screen"
          else "DP-1"
        }"
        "-f 60"
        "-r 60"
        "-c mp4"
        "-k auto"
        "-q very_high"
        "-a default_output|default_input" # game + mic mixed into one track
        "-ac opus"
        "-sc ${onSave}"
        "-o ${replayDir}"
        "-ro ${recordingDir}"
      ];
      KillSignal = "SIGINT";
      # Default 90s; a wedged gsr made toggling look dead while stopping.
      TimeoutStopSec = 5;
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = lib.optionals (!isLaptop) ["sway-session.target"];
  };

  # Games run fullscreen on DP-1 and cover notifications there; show gsr
  # events on the side monitor instead, styled to stand out.
  services.mako.settings = {
    "app-name=\"gsr\"" =
      {
        default-timeout = 4000;
        border-size = 4;
        border-color = config.lib.stylix.colors.withHashtag.base08;
      }
      // lib.optionalAttrs (!isLaptop) {
        output = "HDMI-A-1";
      };
  };

  # Listed in modules-right in waybar.nix. Empty text (service off) hides it.
  programs.waybar.settings.mainBar."custom/gsr" = {
    exec = "${waybarStatus}";
    return-type = "json";
    interval = 1; # drives the REC blink
    signal = waybarSignal;
  };

  programs.waybar.style = ''
    #custom-gsr.recording {
      background-color: #cc2222;
      color: #ffffff;
    }

    #custom-gsr.recording-dim {
      color: #cc2222;
    }
  '';

  wayland.windowManager.sway.config.keybindings = {
    "Mod4+z" = "exec ${save}";
    "Mod4+Shift+z" = "exec ${toggle}";
    "Mod4+x" = "exec ${record}";
  };
}
