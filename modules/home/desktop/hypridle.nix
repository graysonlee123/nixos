{
  config,
  osConfig,
  pkgs,
  isLaptop,
  ...
}: let
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  hyprctl = "${osConfig.programs.hyprland.package}/bin/hyprctl";
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  pidof = "${pkgs.procps}/bin/pidof";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  dpms = action: "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pidof} hyprlock || ${hyprlock}";
        before_sleep_cmd = "${loginctl} lock-session";
        after_sleep_cmd = dpms "enable";
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
            on-timeout = dpms "disable";
            on-resume = dpms "enable";
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
            on-timeout = dpms "disable";
            on-resume = dpms "enable";
          }
        ];
    };
  };
}
