{ pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-4WF7tIx8d6O/Bd0q9GhMch8lS3nlR5N3Zg4ApA3hrKw=";
    };
    environmentFile = "/etc/secrets/caddy.env";
    globalConfig = ''
      acme_dns cloudflare {$CLOUDFLARE_ACCESS_TOKEN}
      admin 127.0.0.1:2019 {
        origins 127.0.0.1:2019 localhost:2019
      }
    '';
    email = "graysonleegantek@gmail.com";
    virtualHosts = {
      # Redirect ggantek.net to my portfolio
      "ggantek.net" = {
        extraConfig = ''
          redir https://graysn.com
        '';
      };
      "jellyfin.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
      };
      "uptime.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:3001
        '';
      };
      "vikunja.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:3456
        '';
      };
    };
  };
}
