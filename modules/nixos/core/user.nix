{
  config,
  pkgs,
  lib,
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
      ++ lib.optionals config.host.formFactor.isLaptop ["video"]
      ++ lib.optionals (!config.host.formFactor.isHeadless) [
        "gamemode"
      ]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager";
    shell = pkgs.zsh;
  };
}
