{pkgs-unstable, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  # 3.16.30 fixes lag bomb (see https://wiki.archlinux.org/title/Gamescope)
  programs.gamescope.package = pkgs-unstable.gamescope;
}
