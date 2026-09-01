{
  config,
  lib,
  constants,
  ...
}:

let
  port = 5173;
  envPath = "kaneo.env";
  secret = "services/kaneo/auth/secret";
  passwordSecret = "services/postgres/kaneo/password";
  ghSecrets = {
    clientId = "external/github/oauth/kaneo/client_id";
    clientSecret = "external/github/oauth/kaneo/client_secret";
  };
  db = {
    name = lib.findFirst (
      x: x == "kaneo"
    ) (throw "missing kaneo") config.services.postgresql.ensureDatabases;
    user =
      (lib.findFirst (
        x: x.name == "kaneo"
      ) (throw "missing kaneo") config.services.postgresql.ensureUsers).name;
    host = constants.network.dockerBridge;
  };
in
{
  # SMTP secrets: declared in modules/nixos/system/sops.nix
  # Example env file: https://github.com/usekaneo/kaneo/blob/main/.env.sample
  sops.secrets.${secret} = { };
  sops.secrets.${passwordSecret} = { };
  sops.secrets.${ghSecrets.clientId} = { };
  sops.secrets.${ghSecrets.clientSecret} = { };
  sops.templates.${envPath}.content = ''
    AUTH_SECRET=${config.sops.placeholder."services/kaneo/auth/secret"}
    SMTP_USER=${config.sops.placeholder."external/postmark/streams/outbound/smtp/username"}
    SMTP_PASSWORD=${config.sops.placeholder."external/postmark/streams/outbound/smtp/password"}
    SMTP_HOST=${config.sops.placeholder."external/postmark/streams/outbound/smtp/host"}
    SMTP_PORT=${config.sops.placeholder."external/postmark/streams/outbound/smtp/port"}
    POSTGRES_PASSWORD=${config.sops.placeholder.${passwordSecret}}
    GITHUB_OAUTH_CLIENT_ID=${config.sops.placeholder.${ghSecrets.clientId}}
    GITHUB_OAUTH_CLIENT_SECRET=${config.sops.placeholder.${ghSecrets.clientSecret}}
  '';

  virtualisation.oci-containers.containers.kaneo = {
    image = "ghcr.io/usekaneo/kaneo:2.22.0@sha256:362139ce143ea5f21c170d2626f654d21991bd48f51340913a54d427b4cfda2c";
    hostname = "kaneo";
    ports = [ "127.0.0.1:${toString port}:5173" ];
    environmentFiles = [ config.sops.templates.${envPath}.path ];
    environment = {
      KANEO_CLIENT_URL = "https://kaneo.lab.ggantek.net";
      POSTGRES_DB = db.name;
      POSTGRES_USER = db.user;
      POSTGRES_HOST = db.host;
      SMTP_FROM = constants.emails.postmark;
      SMTP_SECURE = "false";
    };
  };

  services.caddy.virtualHosts."kaneo.lab.ggantek.net" = {
    extraConfig = ''
      reverse_proxy localhost:${toString port}
    '';
  };
}
