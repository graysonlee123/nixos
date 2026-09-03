{
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
        "networkmanager"
      ];
    shell = pkgs.zsh;
  };
}
