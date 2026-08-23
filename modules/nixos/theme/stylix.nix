{ pkgs, ... }:

{
  stylix = {
    enable = true;
    targets = {
      chromium.enable = false;
    };

    # Even on headless, requires a wallpaper
    image = ../../../assets/images/river.jpg;

    # Gallery: https://tinted-theming.github.io/tinted-gallery/
    # Available themes: https://github.com/tinted-theming/schemes/tree/43dd14f6466a782bd57419fdfb5f398c74d6ac53/base16
    # The available themes are built from that specific revision of tinted-theming/schemes in https://github.com/NixOS/nixpkgs/blob/release-26.05/pkgs/by-name/ba/base16-schemes/package.nix

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-dune.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-terminal-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/jabuti.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/lime.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tarot.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/caroline.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/penumbra-dark-contrast-plus.yaml";

    fonts = {
      serif = {
        package = pkgs.lora;
        name = "Lora";
      };
      sansSerif = {
        package = pkgs.work-sans;
        name = "Work Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.agave;
        name = "Agave Nerd Font";
      };
    };
  };
}
