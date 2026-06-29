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

  services.gameservers = {
    terraria.peepeepoopoo = {
      enable = true;
      worldName = "peepeepoopoo";
      passwordFile = config.sops.secrets."gameservers/terraria/peepeepoopoo/password".path;
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
}
