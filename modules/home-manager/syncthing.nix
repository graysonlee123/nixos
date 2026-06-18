{ lib, ... }:

let
  allDevices = {
    nostromo = {
      id = "5N4LBAT-Q3W7TMI-4QG2Y66-3HUGMR7-PDL7WBJ-OHOBREZ-5P6LHT5-4BRVSQ7";
      addresses = [
        "tcp://100.73.78.2"
        "tcp://192.168.86.38"
      ];
    };
  };
in
{
  services.syncthing = {
    enable = true;
    settings = {
      devices = allDevices;
      folders = {
        "Syncthing" = {
          id = "syncthing";
          path = "/home/gray/syncthing";
          devices = builtins.attrNames allDevices;
        };
      };
    };
  };
}
