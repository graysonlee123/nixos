{ lib, ... }:

{
  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings.shell-integration-features = "ssh-env";
    };
  };
}
