{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      fade-in = 2;
      grace = 5;
      clock = true;
      screenshots = true;
      indicator = true;
      indicator-thickness = 4;
      effect-blur = "7x5";
    };
  };
}
