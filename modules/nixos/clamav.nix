{ pkgs, ... }:

{
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
  environment.systemPackages = [ pkgs.clamav ];
}

