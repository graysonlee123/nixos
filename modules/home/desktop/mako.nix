let
  timeout = 5000;
in {
  services.mako = {
    enable = true;
    settings = {
      border-size = 2;
      width = 400;
      height = 150;
      border-radius = 10;
      outer-margin = 20; # from screen edge
      margin = 6; # between notifications
      padding = "12,14";
      max-icon-size = 48;
      icon-border-radius = 8;
      ignore-timeout = true;
      max-visible = 5;

      # Criteria
      #
      # See https://github.com/emersion/mako/blob/master/doc/mako.5.scd#criteria
      #
      # Useful commands:
      # - makoctl list (show currently displayed notifications)
      # - makoctl history (show dismissed notifications)
      # Track changes already show in waybar. Hide, and expire at once so hidden
      # ones don't pile up (ignore-timeout keeps default-timeout in charge).
      "app-name=\"tidal-hifi\"" = {
        invisible = 1;
        default-timeout = 1;
      };
      "app-name=\"satty\"" = {
        default-timeout = timeout;
      };
    };
  };
}
