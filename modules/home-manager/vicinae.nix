{ config, pkgs, ... }:

{
  config = {
    programs.vicinae = {
      enable = true;
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "pulseaudio";
          src =
            pkgs.fetchFromGitHub {
            owner = "vicinaehq";
              repo = "extensions";
              rev = "cc3326e7e07b4d2d0aa9ebc1a54ee3b0fb1db469";
              sha256 = "sha256-bDC2q3GlDjEE5J2SPHpIdbYKcuLDw3fsxSh3emMOEXU=";
            } + /extensions/pulseaudio;
        })
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
    };
  };
}
