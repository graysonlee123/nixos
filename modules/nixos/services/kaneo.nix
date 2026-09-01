{
  config,
  lib,
  constants,
  ...
}:

let
  port = 5173;
  sops = {
    kaneo = {
      envFile = "kaneo.env";
      auth = {
        secret = "services/kaneo/auth/secret";
      };
    };
    postgres = {
      users = {
        kaneo = {
          password = "services/postgres/kaneo/password";
        };
      };
    };
    github = {
      oauth = {
        clientId = "external/github/oauth/kaneo/client_id";
        clientSecret = "external/github/oauth/kaneo/client_secret";
      };
    };
  };
  postgres = {
    database = lib.findFirst (
      x: x == "kaneo"
    ) (throw "missing kaneo database name") config.services.postgresql.ensureDatabases;
    user =
      (lib.findFirst (
        x: x.name == "kaneo"
      ) (throw "missing kaneo database user") config.services.postgresql.ensureUsers).name;
    host = constants.network.dockerBridge;
  };
in
{
  # SMTP secrets: declared in modules/nixos/system/sops.nix
  # Example env file: https://github.com/usekaneo/kaneo/blob/main/.env.sample
  sops.secrets = {
    ${sops.kaneo.auth.secret} = { };
    ${sops.postgres.users.kaneo.password} = { };
    ${sops.github.oauth.clientId} = { };
    ${sops.github.oauth.clientSecret} = { };
  };
  sops.templates.${sops.kaneo.envFile}.content = ''
    AUTH_SECRET=${config.sops.placeholder.${sops.kaneo.auth.secret}}
    SMTP_USER=${config.sops.placeholder."external/postmark/streams/outbound/smtp/username"}
    SMTP_PASSWORD=${config.sops.placeholder."external/postmark/streams/outbound/smtp/password"}
    SMTP_HOST=${config.sops.placeholder."external/postmark/streams/outbound/smtp/host"}
    SMTP_PORT=${config.sops.placeholder."external/postmark/streams/outbound/smtp/port"}
    POSTGRES_PASSWORD=${config.sops.placeholder.${sops.postgres.users.kaneo.password}}
    GITHUB_OAUTH_CLIENT_ID=${config.sops.placeholder.${sops.github.oauth.clientId}}
    GITHUB_OAUTH_CLIENT_SECRET=${config.sops.placeholder.${sops.github.oauth.clientSecret}}
  '';

  virtualisation.oci-containers.containers.kaneo = {
    image = "ghcr.io/usekaneo/kaneo:2.22.0@sha256:362139ce143ea5f21c170d2626f654d21991bd48f51340913a54d427b4cfda2c";
    hostname = "kaneo";
    ports = [ "127.0.0.1:${toString port}:5173" ];
    environmentFiles = [ config.sops.templates.${sops.kaneo.envFile}.path ];
    environment = {
      KANEO_CLIENT_URL = "https://kaneo.lab.ggantek.net";
      POSTGRES_DB = postgres.database;
      POSTGRES_USER = postgres.user;
      POSTGRES_HOST = postgres.host;
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
