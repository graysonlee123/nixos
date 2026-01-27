{ config, pkgs, ... }:

{
  networking.hostName = "nostromo";

  users.users.gray = {
    isNormalUser = true;
    description = "Grayson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  # Galaxy 70 keyboard - function keys fix
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
