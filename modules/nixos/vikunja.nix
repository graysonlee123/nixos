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
    # Should contain VIKUNJA_MAILER_USERNAME, VIKUNJA_MAILER_PASSWORD
    environmentFiles = [ "/etc/secrets/vikunja.env" ];
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
