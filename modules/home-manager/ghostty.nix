{ lib, ... }:

{
  config = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings.shell-integration-features = "ssh-env";
      settings = {
        background-opacity = 0.97;
      };
    };
  };
}
