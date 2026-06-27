{ config, lib, ... }:

{
  users.users.jellyfin.extraGroups = lib.optional config.services.pinchflat.enable config.services.pinchflat.user;
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
