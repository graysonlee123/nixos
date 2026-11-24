{
  lib,
  config,
  ...
}: let
  cfg = config.host;
  ff = cfg.formFactor.type;
in {
  options.host = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of host.";
      example = "nostromo";
    };

    staticIP = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Static IP of host.";
      default = null;
      example = "192.168.86.2";
    };

    networkInterface = lib.mkOption {
      type = lib.types.str;
      description = "Primary network interface name.";
      default = "eno1";
      example = "enp3s0";
    };
  };

  config = lib.mkMerge [
    {
      networking.hostName = cfg.name;
      networking.enableIPv6 = false;
      networking.firewall.allowedTCPPorts =
        lib.optional (ff != "server") 9003 # Xdebug
        ++ lib.optionals (ff == "server") [
          80 # HTTP
          443 # HTTPS
          7777 # Terraria
        ]
        ++ lib.optionals (ff == "server") (
          lib.mapAttrsToList (_: srv: srv.port) (
            lib.filterAttrs (_: srv: srv.enable) config.services.gameservers.minecraft
          )
        )
        ++ [
          22000 # Syncthing
        ];
      networking.firewall.allowedUDPPorts =
        [21027] # Syncthing discovery
        ++ lib.optionals (ff == "server") (
          lib.concatMap (srv: [srv.port (srv.port + 1)]) (
            lib.attrValues (
              lib.filterAttrs (_: srv: srv.enable) config.services.gameservers.valheim
            )
          )
        );
    }
    (lib.mkIf (cfg.staticIP != null) {
      networking.firewall.interfaces.${cfg.networkInterface}.allowedTCPPorts = [
        22 # SSH
      ];
      networking.firewall.interfaces."docker0".allowedTCPPorts = [
        5432 # PostgreSQL
      ];
      networking.useDHCP = false;
      networking.defaultGateway = config.lan.gateway;
      networking.nameservers = lib.mkDefault config.lan.dns; # overridable, e.g. AGH sets 127.0.0.1
      networking.interfaces.${cfg.networkInterface} = {
        ipv4.addresses = [
          {
            address = cfg.staticIP;
            prefixLength = 24;
          }
        ];
      };
    })
  ];
}
