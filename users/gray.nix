{config, ...}: {
  home-manager.users.gray = {...}: {
    imports = [
      (
        if (config.host.formFactor.type == "server")
        then ../profiles/home/headless.nix
        else ../profiles/home/headed.nix
      )
    ];

    keys.ssh = let
      email = config.emails.personal;
      inspryEmail = config.emails.work;
      sulacoPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUikXnlXo9JwzeSMwdH4PCw/dgKnDYbIgSJxjXSEzMX ${email}";
      bigscootsPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXWYAv1t8J/NJsXrGlnuD2wtY5B/B18rwDgy5ZZzsHp ${inspryEmail}";
    in {
      # Personal
      "github.com" = {
        enable = true;
        sopsFile = "shared.yaml";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMvd+/flMOPe9Ei/FqGC5I73tQSTGq3sh5hD3ymxGn4 ${email}";
        user = "git";
      };
      "sulaco" = {
        enable = config.host.formFactor.type != "server";
        sopsFile = "shared.yaml";
        hostName = config.lan.hosts.sulaco.ips.tailscale;
        publicKey = sulacoPublicKey;
        privateKeyName = "sulaco";
        user = config.users.users.gray.name;
      };
      "sulaco.local" = {
        enable = config.host.formFactor.type != "server";
        sopsFile = "shared.yaml";
        hostName = config.lan.hosts.sulaco.ips.lan;
        publicKey = sulacoPublicKey;
        privateKeyName = "sulaco";
        user = config.users.users.gray.name;
      };

      # Inspry
      "*.pressable.com" = {
        enable = config.host.formFactor.type != "server";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICrAiQZ99gkpglncP8N/zg3y9I8aTfvl4VGaZWWAAuMK ${inspryEmail}";
      };
      "*.ssh.wpengine.net" = {
        enable = config.host.formFactor.type != "server";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9ZyskpBlKwO3lKiiOrj9q8zpS9pkKoOyCiybsVK3Sf ${inspryEmail}";
      };
      "bigscoots" = {
        enable = config.host.formFactor.type != "server";
        hostName = "154.12.120.83";
        publicKey = bigscootsPublicKey;
        user = "nginx";
        port = 2222;
      };
      "ssh.bitbucket.org" = {
        enable = config.host.formFactor.type != "server";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4XIeCOgGQrV7OitP5mMimJSI/bHZDmF/RMmazljroL ${inspryEmail}";
        user = "git";
      };
      "inspry.github.com" = {
        enable = config.host.formFactor.type != "server";
        hostName = "github.com";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuKD0o+ZwnwxkYAg/niixNMzZPeyTDOa84ALYoMA2uQ ${inspryEmail}";
        user = "git";
      };
      "lacrawfish.com" = {
        enable = config.host.formFactor.type != "server";
        hostName = "154.18.246.230";
        publicKey = bigscootsPublicKey;
        user = "nginx";
        port = 2222;
      };
      "rocket.net" = {
        enable = config.host.formFactor.type != "server";
        hostName = "131.153.238.180";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbB3KDWI1xOUJFknHkQfKrtXV42RqdCTpG86DawlxyO ${inspryEmail}";
      };
      "ssh.dev.azure.com" = {
        enable = config.host.formFactor.type != "server";
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6B/D+V7277HHCohcRLhz+QOiMPbOZaaU/mii9hZSEmA3aTWRWuu+v3bLjCRSRFKAUBVWxEnomIcGVmEnLMMjOlnfyEFGxCeJzlkuyV/erKU+RCUE8BqRaixF6ZJuMKb6kELcuNhnXSzl28lN6taTvFvPR47Y/wwcOHYHZwHmUyj1tvbfXL/Z/06lxEJ82UWK25LktJGHuLHIvOSpJ+3U74nPmBwNRPkULOMNUD/uK+Sn35nQjQm6zHZDmleN9XzxfX1+vepIcvJ7DCU8KChyUgeczyQvWWmH0rTZlHVHKRC/YNMdk8Zm/a5k7koFmMPIZp69iJ+QezL0GAZL3U4QWx/9U3ifJNpnthHH0LsYXrk532staHfKivyLSqIf34xVUiOj5WJQrEGAODVQkdbivoosB1IZP7nm4r+hsqenVk1u0BJfGxaNAHEiItHJXaXMfsYdSocMcL0F7k8rI/GcWIXSoCvLjYHhj21Ya/tbBK7QmpPTB25melMAybpt9Rs8= ${inspryEmail}";
      };
      "moosetracks.com" = {
        enable = config.host.formFactor.type != "server";
        hostName = "167.253.104.250";
        publicKey = bigscootsPublicKey;
        user = "nginx";
        port = 2222;
      };
      "spiritelectronics.com" = {
        enable = config.host.formFactor.type != "server";
        hostName = "35.236.219.140";
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOhPbSBruCX3yqbCoTTbeSu+60D7vSPLafAw/JkT+iZC ${inspryEmail}";
        user = "spiritelectronicscom";
        port = 56546;
      };
    };
  };
}
