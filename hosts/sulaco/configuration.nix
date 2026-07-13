{ lib, ... }:

let
  constants = import ../../data/constants.nix;
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
  host.staticIP = constants.hosts.sulaco.ips.lan;
  host.networkInterface = "enp2s0";
  system.stateVersion = "25.11";
  virtualisation.oci-containers.backend = "docker";

  services.gameservers = {
    terraria.peepeepoopoo = {
      enable = true;
    };

    minecraft.test =
      let
        usernames = import ../../data/minecraft-usernames.nix;
      in
      {
        enable = true;
        version = "26.1";
        type = "fabric";
        seed = "test";
        icon = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvignette.wikia.nocookie.net%2Fpeggle%2Fimages%2F8%2F80%2FBjornn3.png%2Frevision%2Flatest%3Fcb%3D20200409114502&f=1&nofb=1&ipt=e75680bc4766798bfb7fcafc95c6c2c4950d8a72281cb5c57caa039be4cbe838";
        whitelist = usernames;
        modrinth = {
          projects = [
            "fabric-api"
            "lithium"
            "appleskin"
            "jade"
            "chunky"
            "rei"
            "distanthorizons:beta"
            "shulkerboxtooltip"
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
