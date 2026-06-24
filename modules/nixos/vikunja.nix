{ config, ... }:

{
  services.vikunja = {
    enable = true;
    frontendScheme = "https";
    frontendHostname = "vikunja.lab.ggantek.net";
    database = {
      database = "vikunja";
      host = "/run/postgresql";
      type = "postgres";
      user = "vikunja";
    };
    environmentFiles = [ config.sops.templates."vikunja.env".path ];
    settings = {
      service = {
        timezone = "America/New_York";
      };
      mailer = {
        enabled = true;
        host = "smtp.postmarkapp.com";
        port = 25;
        fromemail = "postmark@graysn.com";
      };
    };
  };
}
