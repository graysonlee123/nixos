# Dolphin replaces these symlinks when it saves, so in-app changes last until the next switch.
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

  # Hotkeys, with every binding listed so none end up unbound.
  xdg.configFile."dolphin-emu/Hotkeys.ini" = {
    force = true;
    text = toINI {
      Hotkeys = {
        Device = "XInput2/0/Virtual core pointer";
        "General/Open" = "@(Ctrl+O)";
        "General/Toggle Pause" = "F10";
        "General/Stop" = "Escape";
        "General/Toggle Fullscreen" = "@(Alt+Return)";
        "General/Take Screenshot" = "F9";
        "General/Open Achievements" = "@(Alt+A)";
        "Emulation Speed/Disable Emulation Speed Limit" = "Tab";
        "Stepping/Step Into" = "F11";
        "Stepping/Step Over" = "@(Shift+F10)";
        "Stepping/Step Out" = "@(Shift+F11)";
        "Breakpoint/Toggle Breakpoint" = "@(Shift+F9)";
        "Wii/Connect Wii Remote 1" = "@(Alt+F5)";
        "Wii/Connect Wii Remote 2" = "@(Alt+F6)";
        "Wii/Connect Wii Remote 3" = "@(Alt+F7)";
        "Wii/Connect Wii Remote 4" = "@(Alt+F8)";
        "Wii/Connect Balance Board" = "@(Alt+F9)";
        "Load State/Load State Slot 1" = "`F5`";
        "Load State/Load State Slot 2" = "`F6`";
        "Load State/Load State Slot 3" = "`F7`";
        "Load State/Load State Slot 4" = "`F8`";
        "Save State/Save State Slot 1" = "`F1`";
        "Save State/Save State Slot 2" = "`F2`";
        "Save State/Save State Slot 3" = "`F3`";
        "Save State/Save State Slot 4" = "`F4`";
        "Other State Hotkeys/Undo Load State" = "F12";
        "Other State Hotkeys/Undo Save State" = "@(Shift+F12)";
        "GBA Core/Load ROM" = "@(`Ctrl`+`Shift`+`O`)";
        "GBA Core/Unload ROM" = "@(`Ctrl`+`Shift`+`W`)";
        "GBA Core/Reset" = "@(`Ctrl`+`Shift`+`R`)";
        "GBA Volume/Volume Down" = "`KP_Subtract`";
        "GBA Volume/Volume Up" = "`KP_Add`";
        "GBA Volume/Volume Toggle Mute" = "`M`";
        "GBA Window Size/1x" = "`KP_1`";
        "GBA Window Size/2x" = "`KP_2`";
        "GBA Window Size/3x" = "`KP_3`";
        "GBA Window Size/4x" = "`KP_4`";
        "USB Emulation Devices/Show Skylanders Portal" = "@(Ctrl+P)";
        "USB Emulation Devices/Show Infinity Base" = "@(Ctrl+I)";
      };
    };
  };
}
