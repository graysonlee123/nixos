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
    corbelan = {
      id = "LQURRGV-4URVSOT-S2QMDXK-I2KETJD-POFM5CX-4KNHSGR-X2AAV44-5RYCJQJ";
      addresses = [
        "tcp://100.75.203.122"
        "tcp://192.168.86.42"
      ];
    };
    sulaco = {
      id = "UFVX7JU-EKAIN4J-GKUXM3E-BYC46RU-FZ7265C-LJUKXQI-3WDTA6N-D56J6QO";
      addresses = [
        "tcp://100.83.63.8"
        "tcp://192.168.86.2"
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
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "2592000"; # 30 days
            };
          };
        };
      };
    };
  };
}
