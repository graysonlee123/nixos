{ isHeadless, ... }:

{
  services.tailscale = {
    enable = true;
    authKeyFile = if isHeadless then "/run/secrets/tailscale_key" else null;
  };
}
