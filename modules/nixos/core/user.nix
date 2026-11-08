{
  config,
  pkgs,
  lib,
  isHeadless,
  isLaptop,
  ...
}: {
  users.users.gray = {
    isNormalUser = true;
    description = "Grayson";
    extraGroups =
      [
        "wheel"
        "docker"
      ]
      ++ lib.optionals isLaptop ["video"]
      ++ lib.optionals (!isHeadless) [
        "gamemode"
      ]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager";
    shell = pkgs.zsh;
  };
}
