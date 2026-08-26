{
  config,
  lib,
  isHeadless,
  constants,
  hosts,
  ...
}:

let
  cfg = config.gray;
  types = lib.types;
in
{
  options.gray = {
    additionalPackages = lib.mkOption {
      type = types.listOf types.package;
      description = "Additional packages to add to the home manager configuration.";
      example = "[ brightnessctl ]";
      default = [ ];
    };
  };

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.users.gray =
      {
        ...
      }:
      {
        imports = [
          (if isHeadless then ../profiles/home/headless.nix else ../profiles/home/headed.nix)
        ];
        home.packages = cfg.additionalPackages;

        keys.ssh =
          let
            email = constants.emails.personal;
            inspryEmail = constants.emails.work;
            sulacoPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUikXnlXo9JwzeSMwdH4PCw/dgKnDYbIgSJxjXSEzMX ${email}";
            bigscootsPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXWYAv1t8J/NJsXrGlnuD2wtY5B/B18rwDgy5ZZzsHp ${inspryEmail}";
          in
          {
            # Personal
            "github.com" = {
              enable = true;
              sopsFile = "shared.yaml";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMvd+/flMOPe9Ei/FqGC5I73tQSTGq3sh5hD3ymxGn4 ${email}";
              user = "git";
            };
            "sulaco" = {
              enable = !isHeadless;
              sopsFile = "shared.yaml";
              hostName = hosts.sulaco.ips.tailscale;
              publicKey = sulacoPublicKey;
              privateKeyName = "sulaco";
              user = config.users.users.gray.name;
            };
            "sulaco.local" = {
              enable = !isHeadless;
              sopsFile = "shared.yaml";
              hostName = hosts.sulaco.ips.lan;
              publicKey = sulacoPublicKey;
              privateKeyName = "sulaco";
              user = config.users.users.gray.name;
            };

            # Inspry
            "*.pressable.com" = {
              enable = !isHeadless;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrAiQZ99gkpglncP8N/zg3y9I8aTfvl4VGaZWWAAuMK ${inspryEmail}";
            };
            "*.ssh.wpengine.net" = {
              enable = !isHeadless;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9ZyskpBlKwO3lKiiOrj9q8zpS9pkKoOyCiybsVK3Sf ${inspryEmail}";
            };
            "bigscoots" = {
              enable = !isHeadless;
              hostName = "154.12.120.83";
              publicKey = bigscootsPublicKey;
              user = "nginx";
              port = 2222;
            };
            "bitbucket.org" = {
              enable = !isHeadless;
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4XIeCOgGQrV7OitP5mMimJSI/bHZDmF/RMmazljroL ${inspryEmail}";
              user = "git";
            };
            "inspry.github.com" = {
              enable = !isHeadless;
              hostName = "github.com";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuKD0o+ZwnwxkYAg/niixNMzZPeyTDOa84ALYoMA2uQ ${inspryEmail}";
              user = "git";
            };
            "lacrawfish.com" = {
              enable = !isHeadless;
              hostName = "154.18.246.230";
              publicKey = bigscootsPublicKey;
              user = "nginx";
              port = 2222;
            };
            "rocket.net" = {
              enable = !isHeadless;
              hostName = "131.153.238.180";
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbB3KDWI1xOUJFknHkQfKrtXV42RqdCTpG86DawlxyO ${inspryEmail}";
            };
            "ssh.dev.azure.com" = {
              enable = !isHeadless;
              publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6B/D+V7277HHCohcRLhz+QOiMPbOZaaU/mii9hZSEmA3aTWRWuu+v3bLjCRSRFKAUBVWxEnomIcGVmEnLMMjOlnfyEFGxCeJzlkuyV/erKU+RCUE8BqRaixF6ZJuMKb6kELcuNhnXSzl28lN6taTvFvPR47Y/wwcOHYHZwHmUyj1tvbfXL/Z/06lxEJ82UWK25LktJGHuLHIvOSpJ+3U74nPmBwNRPkULOMNUD/uK+Sn35nQjQm6zHZDmleN9XzxfX1+vepIcvJ7DCU8KChyUgeczyQvWWmH0rTZlHVHKRC/YNMdk8Zm/a5k7koFmMPIZp69iJ+QezL0GAZL3U4QWx/9U3ifJNpnthHH0LsYXrk532staHfKivyLSqIf34xVUiOj5WJQrEGAODVQkdbivoosB1IZP7nm4r+hsqenVk1u0BJfGxaNAHEiItHJXaXMfsYdSocMcL0F7k8rI/GcWIXSoCvLjYHhj21Ya/tbBK7QmpPTB25melMAybpt9Rs8= ${inspryEmail}";
            };
            "moosetracks.com" = {
              enable = !isHeadless;
              hostName = config.home-manager.users.gray.keys.ssh.bigscoots.hostName;
              publicKey = config.home-manager.users.gray.keys.ssh.bigscoots.publicKey;
              user = config.home-manager.users.gray.keys.ssh.bigscoots.user;
              port = config.home-manager.users.gray.keys.ssh.bigscoots.port;
            };
            "staging.moosetracks.com" = {
              enable = !isHeadless;
              hostName = config.home-manager.users.gray.keys.ssh.bigscoots.hostName;
              publicKey = config.home-manager.users.gray.keys.ssh.bigscoots.publicKey;
              user = config.home-manager.users.gray.keys.ssh.bigscoots.user;
              port = config.home-manager.users.gray.keys.ssh.bigscoots.port;
            };
          };
      };
  };
}
