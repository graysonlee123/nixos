{ pkgs, ... }:

{
  config = {
    stylix = {
      enable = true;
      targets = {
        chromium.enable = false;
      };

      image = ./../../wallpaper.jpg;

      # base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-dune.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-terminal-dark.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/jabuti.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/lime.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/tarot.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/caroline.yaml";
    };
  };
}

