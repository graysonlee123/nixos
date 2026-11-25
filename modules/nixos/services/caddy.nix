{
  config,
  pkgs,
  ...
}: let
  fileserverPath = "/srv/caddy/fileserver";
in {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
      hash = "sha256-tubXIDCJnO2mvdnPlZclwDhNGaeeYLSt7lnni3+pXDo=";
    };
    environmentFile = config.sops.templates."caddy.env".path;
    globalConfig = ''
      acme_dns cloudflare {$CLOUDFLARE_ACCESS_TOKEN}
    '';
    email = config.emails.gmail;
    virtualHosts = {
      "adguardhome.${config.domains.lab}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.adguardhome.port}
        '';
      };
      "files.${config.domains.root}" = {
        extraConfig = ''
          file_server browse {
            root ${fileserverPath}
          }
        '';
      };
      "${config.domains.root}" = {
        extraConfig = ''
          redir https://${config.domains.personal}
        '';
      };
      "jellyfin.${config.domains.lab}" = {
        # Port should match in-app administration configured port
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
      "links.${config.domains.lab}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.linkdingContainer.port}
        '';
      };
      "pinchflat.${config.domains.lab}" = {
        extraConfig = ''
          reverse_proxy localhost:${toString config.services.pinchflat.port}
        '';
      };
      "syncthing.${config.domains.lab}" = {
        # Port should match home manager Syncthing guiAddress
        extraConfig = ''
          reverse_proxy localhost:8384 {
              header_up Host localhost:8384
          }
        '';
      };
      "uptime.${config.domains.lab}" = {
        extraConfig = ''
          reverse_proxy localhost:${config.services.uptime-kuma.settings.PORT}
        '';
      };
      "vikunja.${config.domains.lab}" = {
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
