{ lib, config, ... }:

let
  cfg = config.services.linkding;
  database = lib.findSingle (x: x == "linkding") null null config.services.postgresql.ensureDatabases;
  user =
    (lib.findSingle (x: x.name == "linkding") null null config.services.postgresql.ensureUsers).name;
in
{
  options.services.linkding = {
    enable = lib.mkEnableOption "Linkding";
    port = lib.mkOption {
      type = lib.types.port;
      description = "Host container port.";
      default = 9090;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.linkding = {
      image = "sissbruecker/linkding@sha256:0f75a89fceff820960cec7a1e5fe46519530e356b0de6b21ca38e8881b9f72e3";
      volumes = [ "/var/lib/linkding:/etc/linkding/data" ];
      ports = [ "127.0.0.1:${toString cfg.port}:9090" ];
      environmentFiles = [ config.sops.templates."postgres/linkding.env".path ];
      environment = {
        LD_DB_ENGINE = "postgres";
        LD_DB_DATABASE = database;
        LD_DB_USER = user;
        LD_DB_HOST = "172.17.0.1";
      };
    };
  };
}
