{ config, lib, ... }:
let
  cfg = config.batsignal;
in
{
  options = {
    batsignal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable batsignal.";
      };
    };
  };

  config = {
    services.batsignal = {
      enable = cfg.enable;
      extraArgs = [];
    };
  };
}

