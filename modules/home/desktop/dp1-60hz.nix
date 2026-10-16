{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  isNostromo = osConfig.networking.hostName == "nostromo";
in {
  # Wrapper that drops DP-1 (LG UltraGear) to 60 Hz while a command runs, then
  # restores 180 Hz. Used as a Steam launch option for Valheim, where 60 Hz gives
  # much better 1% lows than a 60 FPS cap at 180 Hz (VRR doesn't help here).
  # Steam launch option: see docs/gaming.md (Valheim)
  home.packages = lib.mkIf isNostromo [
    (pkgs.writeShellApplication {
      name = "dp1-60hz";
      runtimeInputs = [pkgs.sway];
      text = ''
        swaymsg -q output DP-1 mode 2560x1440@59.951Hz
        trap 'swaymsg -q output DP-1 mode 2560x1440@180.063Hz' EXIT
        trap 'exit 130' INT TERM HUP
        "$@"
      '';
    })
  ];
}
