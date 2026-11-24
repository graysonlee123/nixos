{config, ...}: {
  services.tailscale = {
    enable = true;
    authKeyFile =
      if config.host.formFactor.isHeadless
      then "/etc/secrets/tailscale_key"
      else null;
  };
}
