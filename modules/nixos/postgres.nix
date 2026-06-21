{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
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
