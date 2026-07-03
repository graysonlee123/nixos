{
  config,
  lib,
  ...
}:

let
  cfg = config.keys.ssh;
in
{
  options.keys.ssh = lib.mkOption {
    description = "SSH keys.";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "SSH key";
          hostName = lib.mkOption {
            description = "Host name. Optional. Maps to SSH HostName directive.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          publicKey = lib.mkOption {
            description = "Public key content.";
            type = lib.types.str;
          };
          user = lib.mkOption {
            description = "User name. Optional.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          port = lib.mkOption {
            description = "Port. Optional.";
            type = lib.types.nullOr lib.types.port;
            default = null;
          };
          privateKeyName = lib.mkOption {
            description = "Sops secret and key file name. Defaults to host name.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      }
    );
  };

  config =
    let
      enabledKeys = lib.filterAttrs (_: srv: srv.enable) cfg;
      fileNameOf =
        name: value:
        let
          raw = if value.privateKeyName != null then value.privateKeyName else name;
        in
        lib.removePrefix "*." raw;
    in
    {
      sops = {
        secrets = lib.mapAttrs' (
          name: srv:
          let
            fn = fileNameOf name srv;
          in
          lib.nameValuePair "ssh/keys/${fn}" {
            mode = "0600";
            path = "${config.home.homeDirectory}/.ssh/${fn}";
          }
        ) enabledKeys;
      };

      home.file = lib.mapAttrs' (
        name: srv:
        let
          fn = fileNameOf name srv;
        in
        (lib.nameValuePair ".ssh/${fn}.pub" {
          text = srv.publicKey;
        })
      ) enabledKeys;

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks =
          (lib.mapAttrs' (
            name: srv:
            let
              fn = fileNameOf name srv;
            in
            lib.nameValuePair name {
              identityFile = "${config.home.homeDirectory}/.ssh/${fn}";
              identitiesOnly = true;
              hostname = srv.hostName;
              user = srv.user;
              port = srv.port;
            }
          ))
            enabledKeys;
      };
    };
}
