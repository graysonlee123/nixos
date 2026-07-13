{ lib, config, ... }:

let
  constants = import ../../data/constants.nix;
  radicaleCollections = import ../../data/radicale-collections.nix;
in
{
  sops.secrets."radicale/gray/password" = { };
  accounts.contact = {
    basePath = ".contacts";
    accounts = (
      lib.mapAttrs' (
        name: value:
        lib.nameValuePair name {
          remote = {
            type = "carddav";
            url = "https://radicale.lab.ggantek.net/gray/contacts-${lib.strings.toLower name}/";
            userName = "gray";
            passwordCommand = [
              "/run/current-system/sw/bin/cat"
              "${config.sops.secrets."radicale/gray/password".path}"
            ];
          };
          vdirsyncer.enable = true;
          khard.enable = true;
          khal = {
            enable = true;
            addresses = [ constants.emails.personal ];
            color = "#${value.color}ff";
            priority = value.priority;
          };
        }
      ) (lib.filterAttrs (_: value: value.type == "contacts") radicaleCollections)
    );
  };
}
