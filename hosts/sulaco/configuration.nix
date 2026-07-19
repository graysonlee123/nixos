{ lib, ... }:

let
  hosts = import ../../data/hosts.nix;
  radicaleCollections = import ../../data/radicale-collections.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/headless.nix
    ../../users/gray.nix
  ];

  host.name = "sulaco";
  host.staticIP = hosts.sulaco.ips.lan;
  host.networkInterface = "enp2s0";
  system.stateVersion = "25.11";
  virtualisation.oci-containers.backend = "docker";

  services.gameservers = {
    minecraft.middle-earth =
      let
        usernames = import ../../data/minecraft-usernames.nix;
      in
      {
        enable = true;
        version = "1.21.8";
        type = "fabric";
        seed = "middle-earth";
        icon = "https://cdn.modrinth.com/data/aT3Teaxa/e164de405371a39ab34cd26f8a798131ba6bf4c1.gif";
        whitelist = usernames;
        memory = "4G";
        modrinth = {
          projects = [
            "fabric-api"
            "middle-earth:beta"
            "seven-stars-api:beta"
            "of-beasts-and-wild-things:beta"
            "xaeros-minimap"
            "xaeros-world-map"
            "jade"
            "distanthorizons:beta"
            "rei"
            "appleskin"
          ];
        };
      };
  };

  services.linkding.enable = true;
  services.radicale.collections = (
    lib.mapAttrs (_: value: {
      color = value.color;
      type = value.type;
    }) radicaleCollections
  );
}
