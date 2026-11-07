{
  config,
  pkgs-unstable,
  ...
}: let
  configPath = "${config.home.homeDirectory}/repos/me/nixos/niri/config.kdl";
in {
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink configPath;
  home.packages = [
    # 0.8.2 (nixpkgs-stable) broke Steam context menus
    pkgs-unstable.xwayland-satellite
  ];
}
