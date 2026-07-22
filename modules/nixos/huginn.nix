{ config, lib, ... }:

let
  constants = import ../../data/constants.nix;
  pg = config.services.postgresql;
  port = 1225;
in
{
  virtualisation.oci-containers.containers.huginn = {
    image = "ghcr.io/huginn/huginn@sha256:6935f572b672d981713940fee790e8bbe5d9231a3392c83ad4bd3523eb738182";
    ports = [ "127.0.0.1:${toString port}:3000" ];
    environment = {
      DATABASE_ADAPTER = "postgresql";
      DATABASE_ENCODING = "utf8";
      DATABASE_HOST = constants.network.dockerBridge;
      DATABASE_NAME = lib.findFirst (x: x == "huginn") null pg.ensureDatabases;
      DATABASE_POOL = "5";
      DATABASE_PORT = "5432";
      DATABASE_RECONNECT = "true";
      DATABASE_USERNAME = (lib.findFirst (x: x.name == "huginn") null pg.ensureUsers).name;
      DO_NOT_CREATE_DATABASE = "true";
    };
    environmentFiles = [ config.sops.templates."huginn.env".path ];
  };

  sops.secrets."services/postgres/huginn/password" = { };
  sops.templates."huginn.env".content = ''
    DATABASE_PASSWORD=${config.sops.placeholder."services/postgres/huginn/password"}
  '';

  services.caddy.virtualHosts = {
    "huginn.lab.ggantek.net" = {
      extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
