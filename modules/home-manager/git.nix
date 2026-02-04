{
  config = {
    programs.git = {
      enable = true;
      includes = [
        {
          condition = "gitdir:~/repos/inspry/";
          contents = {
            user = {
              email = "grayson@inspry.com";
            };
            url."git@inspry.github.com:".insteadOf = "git@github.com:";
          };
        }
      ];
      settings = {
        user.name = "Grayson Gantek";
        user.email = "github@graysn.com";
        pull.rebase = false;
        init.defaultBranch = "main";
      };
    };
  };
}
