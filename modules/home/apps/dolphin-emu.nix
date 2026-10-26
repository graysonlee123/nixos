# Dolphin replaces this symlink when it saves, so in-app changes last until the next switch.
{
  config,
  lib,
  pkgs,
  ...
}: let
  toINI = lib.generators.toINI {};
in {
  home.packages = [pkgs.dolphin-emu];

  # Main Dolphin settings.
  xdg.configFile."dolphin-emu/Dolphin.ini" = {
    force = true;
    text = toINI {
      Analytics.PermissionAsked = "True";
      Core = {
        GFXBackend = "Vulkan";
        # All 4 ports use the GameCube adapter in Wii U mode.
        SIDevice0 = 12;
        SIDevice1 = 12;
        SIDevice2 = 12;
        SIDevice3 = 12;
      };
      Display.Fullscreen = "True";
      DSP.DSPThread = "True";
      GBA.SavesInRomPath = "False";
      General = {
        ISOPath0 = "${config.home.homeDirectory}/downloads";
        ISOPaths = 1;
      };
      # Accept input without focus, since sway/XWayland breaks Dolphin's focus check.
      Input.BackgroundInput = "True";
      Interface.ThemeName = "Clean";
      NetPlay.TraversalChoice = "direct";
      SDL_Hints = {
        # Disable SDL HIDAPI, which crashes Dolphin on controller disconnect.
        SDL_JOYSTICK_HIDAPI = 0;
        SDL_JOYSTICK_DIRECTINPUT = 1;
        SDL_JOYSTICK_ENHANCED_REPORTS = 1;
        SDL_JOYSTICK_HIDAPI_COMBINE_JOY_CONS = 1;
        SDL_JOYSTICK_HIDAPI_PS5_PLAYER_LED = 0;
        SDL_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS = 0;
        SDL_JOYSTICK_WGI = 0;
      };
    };
  };
}
