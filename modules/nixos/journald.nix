{
  services.journald.extraConfig = ''
    SystemMaxUse=512M
    SystemKeepFree=128M
    MaxRetentionSec=1week
    MaxFileSec=1week
  '';
}