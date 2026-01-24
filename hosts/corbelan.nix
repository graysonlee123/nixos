{ config, pkgs, ... }:

{
  networking.hostName = "corbelan";

  users.users.gray = {
    isNormalUser = true;
    description = "Grayson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.users.gray = { pkgs, ... }: {
    programs.ghostty = {
      settings = {
        font-size = 10;
      };
    };
  };

  hardware.graphics.enable = true;
}
