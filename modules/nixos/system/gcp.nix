{
  config,
  lib,
  ...
}: {
  sops.secrets."gcp/ggantek-archives/private_key" = {
    sopsFile = ../../../secrets/shared.yaml;
    owner = config.users.users.gray.name;
  };

  sops.templates."gcp/ggantek-archives.json" = {
    content = lib.strings.toJSON {
      type = "service_account";
      project_id = "ggantek-archives";
      private_key_id = "5a41f4394b1f7d37e0c055078dbdb77536dcccc3";
      private_key = config.sops.placeholder."gcp/ggantek-archives/private_key";
      client_email = "archiver@ggantek-archives.iam.gserviceaccount.com";
      client_id = "111617558851520959760";
      auth_uri = "https://accounts.google.com/o/oauth2/auth";
      token_uri = "https://oauth2.googleapis.com/token";
      auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs";
      client_x509_cert_url = "https://www.googleapis.com/robot/v1/metadata/x509/archiver%40ggantek-archives.iam.gserviceaccount.com";
      universe_domain = "googleapis.com";
    };
    owner = config.users.users.gray.name;
  };
}
