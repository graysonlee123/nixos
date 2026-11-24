{
  osConfig,
  config,
  ...
}: {
  sops = {
    defaultSopsFile =
      if osConfig.host.formFactor.isHeadless
      then ../../../secrets/headless.yaml
      else ../../../secrets/headed.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
