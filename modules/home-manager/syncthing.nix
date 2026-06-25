{ config, ... }:

let
  allDevices = {
    nostromo = {
      id = "5N4LBAT-Q3W7TMI-4QG2Y66-3HUGMR7-PDL7WBJ-OHOBREZ-5P6LHT5-4BRVSQ7";
      addresses = [
        "tcp://100.73.78.2:22000"
        "tcp://192.168.86.38:22000"
      ];
    };
    corbelan = {
      id = "LQURRGV-4URVSOT-S2QMDXK-I2KETJD-POFM5CX-4KNHSGR-X2AAV44-5RYCJQJ";
      addresses = [
        "tcp://100.75.203.122:22000"
        "tcp://192.168.86.42:22000"
      ];
    };
    sulaco = {
      id = "E52YS3K-QNNKP2Z-R5LMP6E-7WSRDOC-KMPUGR2-Z4KHKK3-TH2XUBY-6VGJ4AI";
      addresses = [
        "tcp://100.93.40.89:22000"
        "tcp://192.168.86.2:22000"
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
          path = "${config.home.homeDirectory}/syncthing";
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
