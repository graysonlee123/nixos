{
  services.pinchflat = {
    enable = true;
    openFirewall = true;
    selfhosted = true;
    extraConfig = {
      TZ = "America/New_York";
    };
  };
}
