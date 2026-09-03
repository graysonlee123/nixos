let
  port = 3782;
in {
  # Log level: set via main.yaml -> logging.level (in /var/lib/deeptutor).
  # Value is uppercased and resolved through Python's logging module
  # (configure.py). Case-insensitive. Unknown value silently falls
  # back to INFO. Valid names:
  #   - DEBUG
  #   - INFO (default)
  #   - WARNING
  #   - ERROR
  #   - CRITICAL
  # Also accepted: NOTSET, WARN (alias WARNING), FATAL (alias CRITICAL),
  # and a raw int.
  virtualisation.oci-containers.containers.deeptutor = {
    # Version 1.6.0
    image = "ghcr.io/hkuds/deeptutor@sha256:53807413c2cd943b7bd1c9b85b3834c4a05c03586d5694a07172b3a93519439a";
    hostname = "deeptutor";
    ports = ["127.0.0.1:${toString port}:3782"];
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
