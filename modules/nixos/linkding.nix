{ lib, config, ... }:

let
  cfg = config.services.linkding;
in
{
  options.services.linkding = {
    enable = lib.mkEnableOption "Linkding";
    port = lib.mkOption {
      type = lib.types.port;
      description = "Host container port.";
      default = 9090;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.linkding = {
      image = "sissbruecker/linkding@sha256:0f75a89fceff820960cec7a1e5fe46519530e356b0de6b21ca38e8881b9f72e3";
      volumes = [ "/var/lib/linkding:/etc/linkding/data" ];
      ports = [ "${toString cfg.port}:9090" ];
    };
  };
}
