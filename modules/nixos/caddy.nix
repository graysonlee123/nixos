{
  config,
  lib,
  pkgs,
  ...
}:

let
  fileserverPath = "/srv/caddy/fileserver";
in
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-4WF7tIx8d6O/Bd0q9GhMch8lS3nlR5N3Zg4ApA3hrKw=";
    };
    environmentFile = config.sops.templates."caddy.env".path;
    globalConfig = ''
      acme_dns cloudflare {$CLOUDFLARE_ACCESS_TOKEN}
      admin off
    '';
    email = "graysonleegantek@gmail.com";
    virtualHosts = {
      "adguardhome.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.adguardhome.port}
        '';
      };
      "files.ggantek.net" = {
        extraConfig = ''
          file_server browse {
            root ${fileserverPath}
          }
        '';
      };
      "ggantek.net" = {
        extraConfig = ''
          redir https://graysn.com
        '';
      };
      "jellyfin.lab.ggantek.net" = {
        # Port should match in-app administration configured port
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
      "links.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.linkding.port}
        '';
      };
      "pinchflat.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.pinchflat.port}
        '';
      };
      "syncthing.lab.ggantek.net" = {
        # Port should match home manager Syncthing guiAddress
        extraConfig = ''
          reverse_proxy localhost:8384
        '';
      };
      "uptime.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:${config.services.uptime-kuma.settings.PORT}
        '';
      };
      "vikunja.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.vikunja.port}
        '';
      };
    };
  };

  systemd.tmpfiles.settings."10-caddy-fileserver" = {
    "${fileserverPath}" = {
      d = {
        user = config.users.users.gray.name;
        group = config.services.caddy.group;
        mode = "0755";
      };
    };
  };
}
