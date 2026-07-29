{ isHeadless, lib, ... }:

{
  programs.pgcli = {
    enable = true;
    settings.main = lib.mkIf isHeadless {
      keyring = false;
    };
  };
}
