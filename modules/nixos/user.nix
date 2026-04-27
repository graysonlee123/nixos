{ pkgs, ... }:
{
  config = {
    users.users.gray = {
      isNormalUser = true;
      description = "Grayson";
      # TODO: Add "video" group for Corbelan
      extraGroups = [ "networkmanager" "wheel" "docker" "gamemode" ];
      shell = pkgs.zsh;
    };
  };
}
