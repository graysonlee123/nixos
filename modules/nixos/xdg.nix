{ pkgs, lib, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config = {
      sway = {
        default = lib.mkForce [
          "wlr"
        ];
      };
    };
  };
}

