{
  lib,
  config,
  isHeadless,
  ...
}:

let
  dockerUtils = import ../../lib/docker-utils.nix;
in
{
  virtualisation = {
    docker.enable = true;
    oci-containers = lib.mkIf isHeadless {
      backend = "docker";
      containers = {
        terraria =
          let
            worldName = "peepeepoopoo";
          in
          dockerUtils.mkTerrariaServer {
            inherit worldName;
            passwordFile = config.sops.secrets."gameservers/terraria/${worldName}/password".path;
          };
      };
    };
  };
}
