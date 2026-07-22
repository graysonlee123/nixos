{ lib, pkgs, ... }:

let
  constants = import ../../data/constants.nix;
in
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
      "huginn"
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
        name = "huginn";
        ensureDBOwnership = true;
      }
      {
        name = "gray";
        ensureClauses.superuser = true;
      }
    ];
  };
}
