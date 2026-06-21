{ lib, isHeadless, ... }:

{
  config = {
    home.sessionVariables = {
      EDITOR = "vim";
    };
    home.sessionPath = lib.optional (!isHeadless) "$HOME/.config/composer/vendor/bin";
  };
}
