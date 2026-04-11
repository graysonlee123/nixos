{ pkgs, ... }:

{
  programs.waybar.settings.mainBar."custom/mullvad" = {
    return-type = "json";
    interval = 30;
    signal = 11;
    hide-empty-text = true;
    on-click = "${pkgs.mullvad}/bin/mullvad disconnect";
    exec = "${pkgs.writeShellApplication {
      name = "mullvad-status";
      runtimeInputs = [ pkgs.mullvad pkgs.jq ];
      excludeShellChecks = [ "SC2028" ];
      text = ''
        status=$(mullvad status --json)
        state=$(echo "$status" | jq -r '.state')

        case "$state" in
          connected)
            ip=$(echo "$status" | jq -r '.details.location.ipv4 // "?"')
            city=$(echo "$status" | jq -r '(.details.location.city // "Unknown") | split(", ")[0]')
            country=$(echo "$status" | jq -r '.details.location.country // "Unknown"')
            hostname=$(echo "$status" | jq -r '.details.location.hostname // ""')
            echo "{\"text\": \"󰒃 $ip\", \"class\": \"connected\", \"tooltip\": \"$city, $country\n$hostname\"}"
            ;;
          connecting)
            echo '{"text": "󰒃 …", "class": "connecting", "tooltip": "Connecting…"}'
            ;;
          disconnected)
            echo '{"text": ""}'
            ;;
          *)
            echo "{\"text\": \"󰒄 $state\", \"class\": \"error\", \"tooltip\": \"$state\"}"
            ;;
        esac
      '';
    }}/bin/mullvad-status";
  };

  # Watches for mullvad status changes and immediately refreshes the waybar
  # module via SIGRTMIN+11 (matched by `signal = 11` above), rather than
  # waiting for the 30s polling interval.
  #
  # `mullvad status listen` streams a line on every state change. The while
  # loop discards the content and just fires the signal each time.
  #
  # `|| true` prevents the loop from exiting if waybar isn't running yet.
  # Restart = "on-failure" + RestartSec handle the case where mullvad's socket
  # isn't up yet at login.
  systemd.user.services.mullvad-waybar-listener = {
    Unit = {
      Description = "Signal waybar on mullvad status changes";
    };
    Service = {
      ExecStart = pkgs.writeShellScript "mullvad-waybar-listener" ''
        ${pkgs.mullvad}/bin/mullvad status listen | while IFS= read -r _; do
          ${pkgs.procps}/bin/pkill -RTMIN+11 waybar || true
        done
      '';
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "sway-session.target" ];
  };

  programs.waybar.style = ''
    #custom-mullvad {
      padding: 0 10px;
    }

    #custom-mullvad.connected {
      color: #a6e3a1;
    }

    #custom-mullvad.connecting {
      color: #f9e2af;
    }

    #custom-mullvad.error {
      color: #f38ba8;
    }
  '';
}
