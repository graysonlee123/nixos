{ pkgs, ... }:

{
  config = {
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    home.pointerCursor.sway = {
      enable = true;
    };
  };
}
