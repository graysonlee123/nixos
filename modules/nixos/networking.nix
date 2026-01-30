{ lib, config, ... }:

let
  cfg = config.host;
in {
  options.host = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of host.";
      example = "nostromo";
    };
  };

  config = {
    networking.hostName = cfg.name;
    networking.networkmanager.enable = true;
  };
}

