{
  pkgs,
  lib,
  wallpaperPath,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      fade-in = 2;
      grace = 5;
      clock = true;
      image = lib.mkForce wallpaperPath;
      indicator = true;
      indicator-thickness = 4;
      effect-blur = "10x20";
    };
  };
}
