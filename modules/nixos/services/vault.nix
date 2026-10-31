{config, ...}: let
  gcpKey = config.sops.templates."gcp/ggantek-archives.json".path;
  # latest @ 2026-07-07 (post-1.8.2, restic 0.19.1); switch to tag when 1.8.3 ships
  image = "mazzolino/restic@sha256:84a18b739c15216b07dcb9e14985437d49b7a3a68ef8ce48c1323b9f59bf794e";
  networks = config.virtualisation.oci-containers.containers.express-postmark.networks;
  volumes = [
    "${gcpKey}:/config/key.json:ro"
    "${config.sops.secrets."restic/ggantek-archives/password".path}:/config/password:ro"
  ];
  baseEnvironment = {
    RUN_ON_STARTUP = "false";
    SKIP_INIT = "true";
    RESTIC_REPOSITORY = "gs:ggan-vault:/";
    RESTIC_PASSWORD_FILE = "/config/password";
    GOOGLE_PROJECT_ID = "ggantek-archives";
    GOOGLE_APPLICATION_CREDENTIALS = "/config/key.json";
    TZ = "America/New_York";
  };
in {
  systemd.tmpfiles.rules = [
    "d /srv/vault 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    vault-backup = {
      inherit image networks;
      hostname = "vault-backup";
      volumes =
        volumes
        ++ [
          "/srv/vault/data:/vault:ro"
          "/var/lib/syncthing/tarn:/tarn:ro"
        ];
      environment =
        baseEnvironment
        // {
          BACKUP_CRON = "0 0 6 * * *";
          RESTIC_BACKUP_SOURCES = "/vault /tarn";
          RESTIC_BACKUP_ARGS = "--exclude /tarn/.stversions --exclude /tarn/.stfolder";
          RESTIC_RETRY_LOCK = "5m";
          RESTIC_FORGET_ARGS = "--keep-daily 7 --keep-weekly 8 --keep-monthly 24";
          POST_COMMANDS_FAILURE = ''curl -X POST -H 'Content-Type: application/json' -d '{"subject": "VAULT BACKUP FAILURE", "html": "The vault failed to backup.", "text": "The vault failed to backup."}' http://express-postmark:3000'';
          POST_COMMANDS_INCOMPLETE = ''curl -X POST -H 'Content-Type: application/json' -d '{"subject": "VAULT BACKUP INCOMPLETE", "html": "The vault was unable to complete a backup.", "text": "The vault was unable to complete a backup."}' http://express-postmark:3000'';
        };
    };
    vault-prune = {
      inherit image networks volumes;
      hostname = "vault-prune";
      environment =
        baseEnvironment
        // {
          PRUNE_CRON = "0 0 4 1 * *";
          POST_COMMANDS_SUCCESS = ''curl -X POST -H 'Content-Type: application/json' -d '{"subject": "Vault pruned successfully", "html": "The vault was pruned successfully.", "text": "The vault was pruned successfully."}' http://express-postmark:3000'';
          POST_COMMANDS_FAILURE = ''curl -X POST -H 'Content-Type: application/json' -d '{"subject": "VAULT PRUNE FAILURE", "html": "The vault prune failed.", "text": "The vault prune failed."}' http://express-postmark:3000'';
        };
    };
    vault-check = {
      inherit image networks volumes;
      hostname = "vault-check";
      environment =
        baseEnvironment
        // {
          CHECK_CRON = "0 0 8 1,16 * *";
          RESTIC_CHECK_ARGS = "--read-data-subset=33%";
          POST_COMMANDS_SUCCESS = ''curl -X POST -H 'Content-Type: application/json' -d '{"subject": "Vault check successful", "html": "The vault check produced no errors.", "text": "The vault check produced no errors."}' http://express-postmark:3000'';
          POST_COMMANDS_FAILURE = ''curl -X POST -H 'Content-Type: application/json' -d '{"subject": "VAULT CHECK FAILURE", "html": "The vault check failed.", "text": "The vault check failed."}' http://express-postmark:3000'';
        };
    };
  };
}
