{ lib, hosts, ... }:

let
  radicaleCollections = import ../../data/radicale-collections.nix;
  minecraft-players = import ../../data/minecraft-players.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/headless.nix
    ../../users/gray.nix
  ];

  host.name = "sulaco";
  host.staticIP = hosts.sulaco.ips.lan;
  host.networkInterface = "enp2s0";
  system.stateVersion = "25.11";
  virtualisation.oci-containers.backend = "docker";

  services.gameservers = {
    minecraft.august2026 = {
      enable = true;
      memory = "4G";
      version = "26.1.1";
      type = "fabric";
      difficulty = "normal";
      seed = "august2026";
      whitelist = map (v: v.uuid) minecraft-players; 
      motd = "August 2026";
      modrinth.projects = [
        "appleskin"
        "chunky"
        "distanthorizons:beta"
        "fabric-api"
        "jade"
        "jei:beta"
        "lithium"
        "rei"
        "shulkerboxtooltip"
      ];
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
