{
  config,
  isHeadless,
  ...
}:

{
  sops = {
    defaultSopsFile = if isHeadless then ../../secrets/headless.yaml else ../../secrets/headed.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
