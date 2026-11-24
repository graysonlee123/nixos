{config, ...}: {
  services.tailscale = {
    enable = true;
    authKeyFile =
      if (config.host.formFactor.type == "server")
      then "/etc/secrets/tailscale_key"
      else null;
  };
}
