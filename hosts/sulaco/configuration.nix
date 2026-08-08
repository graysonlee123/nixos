{ lib, hosts, ... }:

let
  radicaleCollections = import ../../data/radicale-collections.nix;
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

  services.gameservers = { };

  services.linkding.enable = true;
  services.radicale.collections = (
    lib.mapAttrs (_: value: {
      color = value.color;
      type = value.type;
    }) radicaleCollections
  );
}
