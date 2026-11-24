{config, ...}: {
  services.pinchflat = {
    enable = true;
    port = 8945;
    selfhosted = true;
    extraConfig.TZ = config.time.timeZone;
  };
}
