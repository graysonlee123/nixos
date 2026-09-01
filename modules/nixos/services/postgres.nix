{
  lib,
  pkgs,
  constants,
  ...
}:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    settings = {
      listen_addresses = lib.mkForce "localhost,${constants.network.dockerBridge}";
    };
    authentication = lib.mkAfter ''
      host all all ${constants.network.dockerSubnet} md5
    '';
    ensureDatabases = [
      "vikunja"
      "linkding"
      "kaneo"
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
        name = "kaneo";
        ensureDBOwnership = true;
      }
      {
        name = "gray";
        ensureClauses.superuser = true;
      }
    ];
  };

  systemd.services.postgresql = {
    after = [
      "docker.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
  };
}
