{
  osConfig,
  lib,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "vim";
  };
  home.sessionPath = lib.optional (osConfig.host.formFactor.type != "server") "$HOME/.config/composer/vendor/bin";
}
