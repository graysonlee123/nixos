{
  lib,
  hosts,
  ...
}: let
  radicaleCollections = import ../../data/radicale-collections.nix;
  minecraft-players = import ../../data/minecraft-players.nix;
in {
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
      version = "26.1.2";
      type = "fabric";
      difficulty = "normal";
      seed = "august2026";
      whitelist = map (v: v.uuid) minecraft-players;
      motd = "August 2026";
      packwiz.url = "https://raw.githubusercontent.com/graysonlee123/packwiz-vanilla-plus/main/pack.toml";
    };

    valheim.vikings = {
      enable = true;
      serverName = "Da viking bois";
    };

    valheim.nora = {
      enable = true;
      serverName = "Julep's server";
      port = 2458;
      valheimPlus = true;
    };
  };

  services.linkdingContainer.enable = true;
  services.radicale.collections = (
    lib.mapAttrs (_: value: {
      color = value.color;
      type = value.type;
    })
    radicaleCollections
  );
}
