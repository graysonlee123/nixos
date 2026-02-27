{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        # Personal
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
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

        # Inspry
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
        "3.82.7.41" = {
          identityFile = "~/.ssh/azenco";
          identitiesOnly = true;
        };
      };
    };
  };
}
