{
  config,
  lib,
  ...
}:

let
  cfg = config.services.gameservers;
  gameserverDir = "/var/lib/gameservers";
in
{
  options.services.gameservers = {
    terraria = lib.options.mkOption {
      description = "Terraria servers to run within Docker.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Terraria server";
            worldName = lib.mkOption {
              description = "World name. Treated as a slug for server setup. Used in world name itself, password path, host password path, world file name.";
              type = lib.types.nonEmptyStr;
            };
            port = lib.mkOption {
              description = "Host container port.";
              type = lib.types.port;
              default = 7777;
            };
            passwordFile = lib.mkOption {
              description = "Password file for the server.";
              type = lib.types.pathWith {
                absolute = true;
                inStore = false;
              };
            };
          };
        }
      );
      default = { };
    };
  };

  config = {
    virtualisation.oci-containers.containers = lib.mapAttrs' (
      name: srv:
      let
        passwordPath = "/run/secrets/${srv.worldName}/password";
      in
      lib.nameValuePair "terraria-${name}" {
        image = "ryshe/terraria@sha256:55539b1d972159109875c1ba8bda221b718983a8fd4726e6ff8249a026233fd5";
        entrypoint = "/bin/sh";
        cmd = [
          "-c"
          ''exec /terraria-server/bootstrap.sh -password "$(tr -d '\n' < ${passwordPath})"''
        ];
        volumes = [
          "${gameserverDir}/terraria/${srv.worldName}:/root/.local/share/Terraria/Worlds"
          "${srv.passwordFile}:${passwordPath}"
        ];
        ports = [ "${toString srv.port}:7777" ];
        environment = {
          "WORLD_FILENAME" = "${srv.worldName}.wld";
        };
      }
    ) (lib.filterAttrs (_: srv: srv.enable) cfg.terraria);
  };
}
