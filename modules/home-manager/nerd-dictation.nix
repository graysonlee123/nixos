{ pkgs, ... }:

# Push-to-talk dictation using whisper-cpp.
# First keypress starts recording; second stops, transcribes, and types result.
#
# Setup: run `whisper-cpp-download-ggml-model base.en` to download the model.
# It will be saved to the current directory; move it to ~/.local/share/whisper/model.bin

let
  recording = "/tmp/dictation.wav";
  pidfile = "/tmp/dictation.pid";
  outfile = "/tmp/dictation";
  statusfile = "/tmp/dictation-status";

  toggleScript = pkgs.writeShellScript "dictation-toggle" ''
    if [ -f "${pidfile}" ]; then
      kill "$(cat "${pidfile}")" 2>/dev/null
      rm -f "${pidfile}"
      echo "transcribing" > "${statusfile}"
      pkill -RTMIN+10 waybar
      sleep 0.3
      ${pkgs.whisper-cpp}/bin/whisper-cli \
        -m "$HOME/.local/share/whisper/model.bin" \
        -f "${recording}" \
        -otxt \
        -of "${outfile}" \
        -np 2>/dev/null
      ${pkgs.wtype}/bin/wtype "$(sed 's/^[[:space:]]*//' "${outfile}.txt" | tr -d '\n')"
      rm -f "${recording}" "${outfile}.txt" "${statusfile}"
      pkill -RTMIN+10 waybar
    else
      pw-record --rate 16000 --channels 1 --format s16 "${recording}" &
      echo $! > "${pidfile}"
      echo "recording" > "${statusfile}"
      pkill -RTMIN+10 waybar
    fi
  '';

  statusScript = pkgs.writeShellScript "dictation-status" ''
    status=$(${pkgs.coreutils}/bin/cat "${statusfile}" 2>/dev/null)
    if [ "$status" = "recording" ]; then
      echo '{"text": "󰍬 REC", "tooltip": "Recording...", "class": "recording"}'
    elif [ "$status" = "transcribing" ]; then
      echo '{"text": "󰓆 ...", "tooltip": "Transcribing...", "class": "transcribing"}'
    else
      echo '{"text": ""}'
    fi
  '';
in {
  home.packages = with pkgs; [
    whisper-cpp
    wtype
  ];

  wayland.windowManager.sway.config.keybindings = {
    "Mod4+m" = "exec ${toggleScript}";
  };

  programs.waybar.settings.mainBar."custom/dictation" = {
    exec = "${statusScript}";
    return-type = "json";
    interval = 1;
    signal = 10;
  };

  programs.waybar.style = ''
    #custom-dictation.recording {
      color: #ff4444;
    }
    #custom-dictation.transcribing {
      color: #ffaa00;
    }
  '';
}
