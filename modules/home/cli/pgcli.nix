{
  osConfig,
  lib,
  ...
}: {
  programs.pgcli = {
    enable = true;
    settings.main = lib.mkIf osConfig.host.formFactor.isHeadless {
      keyring = false;
    };
  };
}
