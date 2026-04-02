{ pkgs, wttrbar, ... }:

{
  programs.waybar.settings.mainBar."custom/weather" = {
    exec = "LOCATION=Atlanta ${wttrbar}/bin/wttrbar";
    return-type = "json";
    tooltip = true;
    interval = 60 * 5;
    format = "{icon} {text}";
    format-icons = {
      sunny = "o";
      partly-cloudy = "m";
      cloudy = "mm";
      very-cloudy = "mmm";
      fog = "=";
      light-showers = ".";
      light-rain = "/";
      heavy-showers = "//";
      heavy-rain = "///";
      light-sleet = "x";
      light-sleet-showers = "x/";
      light-snow = "*";
      light-snow-showers = "*/";
      heavy-snow = "**";
      heavy-snow-showers = "*/*";
      thundery-showers = "!/";
      thundery-heavy-rain = "/!/";
      thundery-snow-showers = "*!*";
      unknown = "?";
    };
  };
}

