{
  config,
  lib,
  isHeadless,
  ...
}:

let
  allDevices = {
    nostromo = {
      id = "5N4LBAT-Q3W7TMI-4QG2Y66-3HUGMR7-PDL7WBJ-OHOBREZ-5P6LHT5-4BRVSQ7";
      addresses = [
        "tcp://100.73.78.2"
        "tcp://192.168.86.38"
      ];
      autoAcceptFolders = true;
    };
    corbelan = {
      id = "LQURRGV-4URVSOT-S2QMDXK-I2KETJD-POFM5CX-4KNHSGR-X2AAV44-5RYCJQJ";
      addresses = [
        "tcp://100.75.203.122"
        "tcp://192.168.86.42"
      ];
      autoAcceptFolders = true;
    };
    sulaco = {
      id = "E52YS3K-QNNKP2Z-R5LMP6E-7WSRDOC-KMPUGR2-Z4KHKK3-TH2XUBY-6VGJ4AI";
      addresses = [
        "tcp://100.93.40.89"
        "tcp://192.168.86.2"
      ];
      autoAcceptFolders = true;
    };
  };
in
{
  sops.secrets = lib.mkIf isHeadless {
    "services/syncthing/password" = { };
  };

  services.syncthing = {
    enable = true;
    guiAddress = if isHeadless then "0.0.0.0:8384" else "127.0.0.1:8384";
    passwordFile = if isHeadless then config.sops.secrets."services/syncthing/password".path else null;
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

  home.file."syncthing/.stignore".text = ''
    .git
    node_modules
    vendor
    .next
    .idea
    .vscode
    *.swp
    *.swo
    *~
    .DS_Store
    .Trash-*
    *.tmp
    *.temp
    *.log
  '';
}
