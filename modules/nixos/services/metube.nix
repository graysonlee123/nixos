{config, ...}: let
  port = 8081;
  dataDir = "/var/lib/metube";
in {
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 1000 100 -"
  ];

  virtualisation.oci-containers.containers.metube = {
    image = "ghcr.io/alexta69/metube:2026.11.06@sha256:96dfbf0d5b2944e4ee38f6ce1b34bb0e75a1a3c74eaefd93424ed11284cb72b2";
    hostname = "metube";
    ports = ["127.0.0.1:${toString port}:8081"];
    volumes = ["${dataDir}:/downloads"];
    environment = {
      TZ = config.time.timeZone;
      PUID = "1000";
      PGID = "100";
      DELETE_FILE_ON_TRASHCAN = "ask";
    };
  };

  services.caddy.virtualHosts."metube.${config.domains.lab}" = {
    extraConfig = ''
      reverse_proxy localhost:${toString port}
    '';
  };
}
