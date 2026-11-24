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
      ++ lib.optionals (config.host.formFactor.type == "laptop") ["video"]
      ++ lib.optionals (config.host.formFactor.type != "server") ["gamemode"]
      ++ lib.optionals config.networking.networkmanager.enable ["networkmanager"];
    shell = pkgs.zsh;
  };
}
