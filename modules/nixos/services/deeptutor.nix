let
  port = 3782;
in
{
  virtualisation.oci-containers.containers.deeptutor = {
    # Version 1.6.0
    image = "ghcr.io/hkuds/deeptutor@sha256:53807413c2cd943b7bd1c9b85b3834c4a05c03586d5694a07172b3a93519439a";
    hostname = "deeptutor";
    ports = [ "127.0.0.1:${toString port}:3782" ];
    volumes = [
      "/var/lib/deeptutor:/app/data"
    ];
  };

  services.caddy.virtualHosts."deeptutor.lab.ggantek.net" = {
    extraConfig = ''
      reverse_proxy localhost:${toString port}
    '';
  };
}
