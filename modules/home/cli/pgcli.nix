{
  osConfig,
  lib,
  ...
}: {
  programs.pgcli = {
    enable = true;
    settings.main = lib.mkIf (osConfig.host.formFactor.type == "server") {
      keyring = false;
    };
  };
}
