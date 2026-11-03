{
  lib,
  osConfig,
  ...
}: let
  hasFingerprint = osConfig.services.fprintd.enable;

  # Nostromo: widgets on main monitor only, others just show the background.
  widgetMonitor =
    if osConfig.networking.hostName == "nostromo"
    then "DP-1"
    else "";
in {
  # Stylix themes colors and sets the wallpaper as background. Avoid
  # `path = "screenshot"`: screencopy timed out on Nostromo (NVIDIA) and the
  # lock screen froze.
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
      };

      # Fingerprint via fprintd D-Bus, in parallel with the password field.
      # PAM fprintAuth stays off for hyprlock (it blocks password entry).
      auth = lib.mkIf hasFingerprint {
        "fingerprint:enabled" = true;
      };

      background = {
        monitor = "";
        blur_passes = 3;
        blur_size = 8;
        brightness = 0.6;
      };

      label = [
        {
          monitor = widgetMonitor;
          text = "$TIME12";
          font_size = 96;
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          monitor = widgetMonitor;
          text = ''cmd[update:60000] date +"%A, %B %-d"'';
          font_size = 20;
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        monitor = widgetMonitor;
        size = "300, 50";
        position = "0, -60";
        halign = "center";
        valign = "center";
        outline_thickness = 2;
        dots_center = true;
        fade_on_empty = false;
        placeholder_text =
          if hasFingerprint
          then "Password or fingerprint"
          else "Password";
      };
    };
  };
}
