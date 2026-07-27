let
  port = 3782;
in
{
  virtualisation.oci-containers.containers.deeptutor = {
    image = "ghcr.io/hkuds/deeptutor@sha256:b07c9ed2ea573384ded5dc174abb812c2ec9249ae5aa48766e8b58f446525cde";
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
