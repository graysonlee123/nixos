{config, ...}: {
  services.vikunja = {
    enable = true;
    port = 3456;
    frontendScheme = "https";
    frontendHostname = "vikunja.${config.domains.lab}";
    database = {
      database = "vikunja";
      host = "/run/postgresql";
      type = "postgres";
      user = "vikunja";
    };
    environmentFiles = [config.sops.templates."vikunja.env".path];
    settings = {
      service.timezone = config.time.timeZone;
      mailer = {
        enabled = true;
        host = "smtp.postmarkapp.com";
        port = 25;
        fromemail = "postmark@${config.domains.personal}";
      };
    };
  };
}
