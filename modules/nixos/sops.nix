{
  isHeadless,
  lib,
  config,
  ...
}:

{
  sops = {
    defaultSopsFile = ../../secrets/headless.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.users.users.gray.home}/.config/sops/age/keys.txt";

    secrets = lib.mkIf isHeadless {
      "services/caddy/cloudflare_access_token" = { };
      "services/vikunja/mailer_username" = { };
      "services/vikunja/mailer_password" = { };
    };

    templates = lib.mkIf isHeadless {
      "vikunja.env".content = ''
        VIKUNJA_MAILER_USERNAME=${config.sops.placeholder."services/vikunja/mailer_username"}
        VIKUNJA_MAILER_PASSWORD=${config.sops.placeholder."services/vikunja/mailer_password"}
      '';
      "caddy.env".content = ''
        CLOUDFLARE_ACCESS_TOKEN=${config.sops.placeholder."services/caddy/cloudflare_access_token"}
      '';
    };
  };
}
