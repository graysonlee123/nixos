{
  config,
  osConfig,
  pkgs,
  isLaptop,
  ...
}: let
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  niri = "${osConfig.programs.niri.package}/bin/niri";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  pidof = "${pkgs.procps}/bin/pidof";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  monitorsOff = "${niri} msg action power-off-monitors";
  monitorsOn = "${niri} msg action power-on-monitors";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pidof} hyprlock || ${hyprlock}";
        before_sleep_cmd = "${loginctl} lock-session";
        after_sleep_cmd = monitorsOn;
      };

      # Laptop: short timeouts, dim first, suspend at the end.
      # Desktop: much longer timeouts, no dim (no backlight), never suspend.
      listener =
        if isLaptop
        then [
          {
            timeout = 150;
            on-timeout = "${brightnessctl} -s set 10%";
            on-resume = "${brightnessctl} -r";
          }
          {
            timeout = 300;
            on-timeout = "${loginctl} lock-session";
          }
          {
            timeout = 330;
            on-timeout = monitorsOff;
            on-resume = monitorsOn;
          }
          {
            timeout = 900;
            on-timeout = "${systemctl} suspend";
          }
        ]
        else [
          {
            timeout = 1800;
            on-timeout = "${loginctl} lock-session";
          }
          {
            timeout = 2700;
            on-timeout = monitorsOff;
            on-resume = monitorsOn;
          }
        ];
    };
  };
}
