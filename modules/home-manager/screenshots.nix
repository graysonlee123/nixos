{
  config = {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          showStartupLaunchMessage = false;
          savePath = "/home/gray/downloads";
        };
      };
    };
  };
}
