{
  osConfig,
  config,
  ...
}: {
  sops = {
    defaultSopsFile =
      if (osConfig.host.formFactor.type == "server")
      then ../../../secrets/headless.yaml
      else ../../../secrets/headed.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
