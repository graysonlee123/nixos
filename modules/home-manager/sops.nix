{
  config,
  lib,
  isHeadless,
  ...
}:

{
  sops = lib.mkIf isHeadless {
    defaultSopsFile = ../../secrets/headless.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
