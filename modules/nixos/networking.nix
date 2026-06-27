{
  lib,
  config,
  isHeadless,
  ...
}:

let
  cfg = config.host;
in
{
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
        lib.optional (!isHeadless) 9003 # Xdebug
        ++ lib.optionals isHeadless [
          80 # HTTP
          443 # HTTPS
          7777 # Terraria
          25565 # Minecraft
        ]
        ++ [
          22000 # Syncthing
        ];
      networking.firewall.allowedUDPPorts = [ 21027 ]; # Syncthing discovery
    }
    (lib.mkIf (cfg.staticIP != null) {
      networking.firewall.interfaces."docker0".allowedTCPPorts = [
        5432 # PostgreSQL
      ];
      networking.useDHCP = false;
      networking.defaultGateway = "192.168.86.1";
      networking.nameservers = [ "192.168.86.1" ];
      networking.interfaces.${cfg.networkInterface} = {
        ipv4.addresses = [
          {
            address = cfg.staticIP;
            prefixLength = 24;
          }
        ];
      };
    })
    (lib.mkIf (cfg.staticIP == null) {
      networking.networkmanager.enable = true;
    })
  ];
}
