{
  isHeadless,
  lib,
  config,
  ...
}:

{
  sops = {
    defaultSopsFile = ../../../secrets/headless.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.users.users.gray.home}/.config/sops/age/keys.txt";

    secrets = {
      "restic/ggantek-archives/password" = {
        sopsFile = ../../../secrets/shared.yaml;
        owner = if isHeadless then null else "gray";
      };
    }
    // lib.optionalAttrs isHeadless {
      "external/postmark/api_token" = { };
      "external/postmark/streams/outbound/smtp/username" = { };
      "external/postmark/streams/outbound/smtp/password" = { };
      "external/postmark/streams/outbound/smtp/host" = { };
      "external/postmark/streams/outbound/smtp/port" = { };
      "services/caddy/cloudflare_access_token" = { };
      "services/postgres/linkding/password" = { };
      "services/postgres/linkding/superuser_username" = { };
      "services/postgres/linkding/superuser_password" = { };
    };

    templates = lib.mkIf isHeadless {
      "postgres/linkding.env".content = ''
        LD_SUPERUSER_NAME=${config.sops.placeholder."services/postgres/linkding/superuser_username"}
        LD_SUPERUSER_PASSWORD=${config.sops.placeholder."services/postgres/linkding/superuser_password"}
        LD_DB_PASSWORD=${config.sops.placeholder."services/postgres/linkding/password"}
      '';
      "vikunja.env".content = ''
        VIKUNJA_MAILER_USERNAME=${config.sops.placeholder."external/postmark/api_token"}
        VIKUNJA_MAILER_PASSWORD=${config.sops.placeholder."external/postmark/api_token"}
      '';
      "caddy.env".content = ''
        CLOUDFLARE_ACCESS_TOKEN=${config.sops.placeholder."services/caddy/cloudflare_access_token"}
      '';
    };
  };
}
