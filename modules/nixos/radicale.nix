{ lib, config, ... }:

let
  port = 5232;
  secret = "services/radicale/gray/password";
  collectionPath = "/var/lib/radicale/collections/collection-root/gray";
  collections = config.services.radicale.collections;
  collectionList = lib.mapAttrsToList (_: value: {
    name = value.name;
    color = value.color;
    type = value.type;
  }) collections;
  collectionDir = collection:
    "${collectionPath}/${collection.type}-${lib.strings.toLower collection.name}";
  mkRadicalePropsFile = collection:
    builtins.toFile "${collection.type}-${lib.strings.toLower collection.name}-props" (
      builtins.toJSON (
        if collection.type == "calendar" then {
          "C:supported-calendar-component-set" = "VEVENT";
          "D:displayname" = collection.name;
          "ICAL:calendar-color" = "#${collection.color}ff";
          "ICAL:calendar-order" = "0";
          "tag" = "VCALENDAR";
        } else {
          "D:displayname" = collection.name;
          "{http://inf-it.com/ns/ab/}addressbook-color" = "#${collection.color}ff";
          "tag" = "VADDRESSBOOK";
        }
      )
    );
in
{
  options = {
    services.radicale.collections = lib.mkOption {
      description = "Radicale collections.";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                description = "Collection name. Set to attribute name by default.";
                type = lib.types.str;
                readOnly = true;
              };
              color = lib.mkOption {
                description = "Collection color.";
                default = "ffffff";
                type = lib.types.strMatching "[0-9a-fA-F]{6}";
              };
              type = lib.mkOption {
                description = "Collection type.";
                type = lib.types.enum [
                  "calendar"
                  "contacts"
                ];
              };
            };

            config = { inherit name; };
          }
        )
      );
    };
  };

  config = {
    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "0.0.0.0:${toString port}" ];
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = config.sops.templates.radicale.path;
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    systemd.tmpfiles.rules = map (
      collection:
      "d ${collectionDir collection} 0750 radicale radicale -"
    ) collectionList;

    systemd.services.radicale.preStart = builtins.concatStringsSep "\n" (
      map (
        collection:
        "cp ${mkRadicalePropsFile collection} ${collectionDir collection}/.Radicale.props"
      ) collectionList
    );

    sops = {
      secrets.${secret} = { };
      templates."radicale" = {
        owner = "radicale";
        path = "/etc/radicale/htpasswd";
        content = ''
          gray:${config.sops.placeholder.${secret}}
        '';
      };
    };

    services.caddy.virtualHosts = {
      "radicale.lab.ggantek.net" = {
        extraConfig = ''
          reverse_proxy localhost:${toString port}
        '';
      };
    };
  };
}
