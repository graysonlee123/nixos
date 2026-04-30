{ config, pkgs, ... }:

{
  config = {
    systemd.user.services.vicinae.Service.Environment =
      "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin";

    programs.vicinae = {
      enable = true;
      settings = {
        theme = {
          name = "stylix";
        };
      };
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "nix";
          src =
            pkgs.fetchFromGitHub {
            owner = "vicinaehq";
              repo = "extensions";
              rev = "62bcab8ca590d37c8443cb2aee2e83ef656e389f";
              sha256 = "sha256-j3g10f7sHHPbcN6tQIJmKatyOANJzHc5o9zAQlNrnOw=";
            } + /extensions/nix;
        })
      ];
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
    };
  };
}
