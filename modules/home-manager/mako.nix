let
  timeout = 5000;
in {
  config = {
    services.mako = {
      enable = true;
      settings = {
        border-size = 2;
        width = 400;
        height = 150;
        ignore-timeout = true;
        max-visible = 5;

        # Criteria
        #
        # See https://github.com/emersion/mako/blob/master/doc/mako.5.scd#criteria
        #
        # Useful commands:
        # - makoctl list (show currently displayed notifications)
        # - makoctl history (show dismissed notifications)
        "app-name=\"tidal-hifi\"" = {
          default-timeout = timeout;
          anchor = "top-center";
          icon-location = "top";
          text-alignment = "left";
          width = 256;
        };
        "desktop-entry=\"com.mitchellh.ghostty\"" = {
          default-timeout = timeout;
        };
        "app-name=\"satty\"" = {
          default-timeout = timeout;
        };
      };
    };
  };
}
