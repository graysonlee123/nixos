{ config, pkgs, ... }:

{
  networking.hostName = "corbelan";

  users.users.gray = {
    isNormalUser = true;
    description = "Grayson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  hardware.graphics.enable = true;
}
