{
  osConfig,
  lib,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "vim";
  };
  home.sessionPath = lib.optional (!osConfig.host.formFactor.isHeadless) "$HOME/.config/composer/vendor/bin";
}
