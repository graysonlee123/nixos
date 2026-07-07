{ lib, isHeadless, ... }:

let
  constants = import ../../data/constants.nix;
in
{
  config = {
    programs.git = {
      enable = true;
      includes = lib.optionals (!isHeadless) [
        {
          condition = "gitdir:~/repos/inspry/";
          contents = {
            user = {
              email = constants.emails.work;
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
