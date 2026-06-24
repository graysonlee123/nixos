let
  gameserverDir = "/var/lib/gameservers";
in
rec {
  mkDockerContainer =
    {
      image,
      cmd ? [ ],
      entrypoint ? null,
      env ? { },
      envFiles ? [ ],
      extraOptions ? [ ],
      networks ? [ ],
      ports ? [ ],
      volumes ? [ ],
      user ? null,
    }:
    {
      inherit
        image
        cmd
        extraOptions
        entrypoint
        networks
        ports
        volumes
        user
        ;
      autoRemoveOnStop = true;
      autoStart = true;
      environment = env;
      environmentFiles = envFiles;
    };
  mkTerrariaServer =
    {
      worldName,
      port ? 7777,
      passwordFile,
    }:
    let
      passwordPath = "/run/secrets/${worldName}/password";
    in
    mkDockerContainer {
      image = "ryshe/terraria@sha256:55539b1d972159109875c1ba8bda221b718983a8fd4726e6ff8249a026233fd5";
      ports = [ "${toString port}:7777" ];
      entrypoint = "/bin/sh";
      cmd = [
        "-c"
        ''exec /terraria-server/bootstrap.sh -password "$(tr -d '\n' < ${passwordPath})"''
      ];
      volumes = [
        "${gameserverDir}/terraria/${worldName}:/root/.local/share/Terraria/Worlds"
        "${passwordFile}:${passwordPath}"
      ];
      env = {
        "WORLD_FILENAME" = "${worldName}.wld";
      };
    };
}
