{ pkgs, ... }:

{
  services.clamav = {
    updater.enable = true;
    updater.frequency = 1;
  };
  environment.systemPackages = [ pkgs.clamav ];
}

