{ isHeadless, ... }:

{
  services.tailscale = {
    enable = true;
    authKeyFile = if isHeadless then "/etc/secrets/tailscale_key" else null;
  };
}
