{ pkgs, lib, config, ... }:

let
  cfg = config.greeter;
in {
  options.greeter.unsupportedGpu = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = "Whether or not to pass the '--unsupported-gpu' flag to Sway.";
  };

  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"${if cfg.unsupportedGpu then "sway --unsupported-gpu" else "sway"}\"";
          user = "greeter";
        };
      };
    };
  };
}
