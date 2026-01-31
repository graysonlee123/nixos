{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
          identitiesOnly = true;
        };
        "inspry.github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github-inspry";
          identitiesOnly = true;
        };
        "154.12.120.83" = {
          identityFile = "~/.ssh/bigscoots";
          identitiesOnly = true;
        };
        "sulaco" = {
          hostname = "100.83.63.8";
          user = "grayson";
          identityFile = "~/.ssh/sulaco";
          identitiesOnly = true;
        };
        "sulaco.local" = {
          hostname = "192.168.86.2";
          user = "grayson";
          identityFile = "~/.ssh/sulaco";
          identitiesOnly = true;
        };
      };
    };
  };
}
