{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        # Match Discord stream fps; capturing 60 wastes half the frames (CPU encode on NVIDIA)
        max_fps = 30;
      };
    };
  };
}
