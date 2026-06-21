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
      description = "Static IP of host. Enables systemd-networkd when set.";
      default = null;
      example = "192.168.86.2";
    };
  };

  config = lib.mkMerge [
    {
      networking.hostName = cfg.name;
      networking.enableIPv6 = false;
      networking.firewall.allowedTCPPorts = lib.optional (!isHeadless) 9003; # Xdebug
    }
    (lib.mkIf (cfg.staticIP != null) {
      systemd.network.enable = true;
      systemd.network.networks."10-lan" = {
        matchConfig.Type = "ether";
        address = [ "${cfg.staticIP}/24" ];
        gateway = [ "192.168.86.1" ];
        dns = [ "192.168.86.1" ];
      };
    })
    (lib.mkIf (cfg.staticIP == null) {
      networking.networkmanager.enable = true;
    })
  ];
}
