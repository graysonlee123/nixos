{lib, ...}: {
  options = {
    lan = lib.mkOption {
      description = "Home LAN configuration.";
      default = {};
      type = lib.types.submodule {
        options = {
          gateway = lib.mkOption {
            description = "Default gateway of home network.";
            type = lib.types.str;
          };
          subnetMask = lib.mkOption {
            description = "Subnet mask.";
            type = lib.types.str;
          };
          rangeStart = lib.mkOption {
            description = "DHCP server range start (AdGuard Home).";
            type = lib.types.str;
          };
          rangeEnd = lib.mkOption {
            description = "DHCP server range end (AdGuard Home).";
            type = lib.types.str;
          };
          dockerBridge = lib.mkOption {
            description = "Docker bridge gateway IP. Containers reach host services (Postgres) here.";
            type = lib.types.str;
          };
          dockerSubnet = lib.mkOption {
            description = "Docker bridge subnet.";
            type = lib.types.str;
          };
          dns = lib.mkOption {
            description = "Default nameservers. Hosts can override them (AdGuard sets 127.0.0.1).";
            type = lib.types.listOf lib.types.str;
          };
          hosts = lib.mkOption {
            description = "Known LAN devices, keyed by ID. Feeds AdGuard clients, Syncthing, bookmarks, SSH.";
            default = {};
            type = lib.types.attrsOf (lib.types.submodule {
              options = {
                label = lib.mkOption {
                  description = "Display name. Used as AdGuard Home client name.";
                  type = lib.types.str;
                };
                ips = lib.mkOption {
                  description = "Host's static IPs. Omit for DHCP-only devices.";
                  default = {};
                  type = lib.types.submodule {
                    options = {
                      tailscale = lib.mkOption {
                        description = "Host's Tailscale IP.";
                        type = lib.types.nullOr lib.types.str;
                        default = null;
                      };
                      lan = lib.mkOption {
                        description = "Host's LAN IP.";
                        type = lib.types.nullOr lib.types.str;
                        default = null;
                      };
                    };
                  };
                };
                mac = lib.mkOption {
                  description = "Host's MAC address. Used for AdGuard Home device mappings.";
                  type = lib.types.strMatching "([0-9a-f]{2}:){5}[0-9a-f]{2}";
                };
                uuid = lib.mkOption {
                  description = "Host's UUID. Used as AdGuard Home persistent client ID.";
                  type = lib.types.strMatching "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";
                };
              };
            });
          };
        };
      };
    };
  };

  config.lan = import ../../../data/lan.nix;
}
