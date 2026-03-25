{ pkgs, ... }:

let
  toggleScript = pkgs.writeShellScript "weather" ''
    for i in {1..5}
    do
      text=$(${pkgs.curl}/bin/curl -s "https://wttr.in/$1?format=1&u")
      if [[ $? == 0 ]]
      then
        text=$(echo "$text" | ${pkgs.gnused}/bin/sed -E "s/\s+/ /g")
        tooltip=$(${pkgs.curl}/bin/curl -s "https://wttr.in/$1?format=4&u")
        if [[ $? == 0 ]]
        then
          tooltip=$(echo "$tooltip" | ${pkgs.gnused}/bin/sed -E "s/\s+/ /g")
          echo "{\"text\":\"$text\", \"tooltip\": \"$tooltip\"}"
          exit
        fi
      fi
      ${pkgs.coreutils}/bin/sleep 2
    done
    echo "{\"text\": \"error\", \"tooltip\": \"error\"}"
  '';
in {
  programs.waybar.settings.mainBar."custom/weather" = {
    exec = "${toggleScript} 30339";
    return-type = "json";
    format = "{}";
    tooltip = true;
    interval = 3600;
  };
}

