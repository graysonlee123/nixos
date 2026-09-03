let
  port = 5000;
in {
  virtualisation.oci-containers.containers.kavita = {
    image = "ghcr.io/kareadita/kavita:0.9.0.2@sha256:880a8feff0833e860575f8e08788e4b4f59f8659afd17206566aae88a525130d";
    hostname = "kavita";
    ports = ["127.0.0.1:${toString port}:5000"];
    volumes = [
      "/var/lib/kavita:/kavita/config"
      "/srv/vault/data/media/books:/books:ro"
    ];
    environment = {
      TZ = "America/New_York";
    };
  };

  services.caddy.virtualHosts."kavita.lab.ggantek.net" = {
    extraConfig = ''
      reverse_proxy localhost:${toString port}
    '';
  };
}
