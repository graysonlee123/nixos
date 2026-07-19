{ config, pkgs, ... }:

let
  secret = "services/express_postmark/postmark_api_token";
  constants = import ../../data/constants.nix;
  network = "express-postmark";
in
{
  sops.secrets.${secret} = { };
  sops.templates."express-postmark/.env".content = ''
    POSTMARK_API_TOKEN=${config.sops.placeholder.${secret}}
    EMAIL_FROM=${constants.emails.postmark}
    EMAIL_TO=${constants.emails.personal}
  '';

  system.activationScripts.mkExpressPostmarkNetwork = ''
    ${pkgs.docker}/bin/docker network inspect ${network} > /dev/null 2>&1 || ${pkgs.docker}/bin/docker network create ${network}
  '';

  virtualisation.oci-containers.containers.express-postmark = {
    image = "ghcr.io/graysonlee123/express-postmark@sha256:cfd722a85e4860077dc8e80cd9a2495f9953a359d7fcc53ec581f0171c46ab88";
    hostname = "express-postmark";
    networks = [ network ];
    ports = [ "127.0.0.1:1224:3000" ];
    environmentFiles = [
      config.sops.templates."express-postmark/.env".path
    ];
  };
}
