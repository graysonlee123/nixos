{ lib, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    settings = {
      listen_addresses = lib.mkForce "localhost,172.17.0.1";
    };
    authentication = lib.mkAfter ''
      host all all 172.17.0.0/16 md5
    '';
    ensureDatabases = [
      "vikunja"
      "linkding"
    ];
    ensureUsers = [
      {
        name = "vikunja";
        ensureDBOwnership = true;
      }
      {
        name = "linkding";
        ensureDBOwnership = true;
      }
      {
        name = "gray";
        ensureClauses.superuser = true;
      }
    ];
  };
}
