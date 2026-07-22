{ config, ... }:

let
  constants = import ../../data/constants.nix;
in
{
  services.pgadmin = {
    enable = true;
    port = 5050;
    initialEmail = constants.emails.personal;
    initialPasswordFile = config.sops.secrets."services/pgadmin/password".path;
    settings = {
      LOGIN_BANNER = "";
      SERVER_MODE = true;
    };
  };

  services.caddy.virtualHosts."pgadmin.lab.ggantek.net" = {
    extraConfig = ''
      reverse_proxy localhost:${toString config.services.pgadmin.port}
    '';
  };

  sops.secrets."services/pgadmin/password" = { };
}
