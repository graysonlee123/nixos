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
              rev = "cc3326e7e07b4d2d0aa9ebc1a54ee3b0fb1db469";
              sha256 = "sha256-bDC2q3GlDjEE5J2SPHpIdbYKcuLDw3fsxSh3emMOEXU=";
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
