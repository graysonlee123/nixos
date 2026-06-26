{
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/headless.nix
    ../../users/gray.nix
  ];

  host.name = "sulaco";
  host.staticIP = "192.168.86.2";
  host.networkInterface = "enp2s0";
  system.stateVersion = "25.11";
  virtualisation.oci-containers.backend = "docker";

  services.gameservers.terraria.peepeepoopoo = {
    enable = true;
    worldName = "peepeepoopoo";
    passwordFile = config.sops.secrets."gameservers/terraria/peepeepoopoo/password".path;
  };

  services.linkding.enable = true;
}
