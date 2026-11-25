{lib, ...}: let
  display = lib.mkOption {
    description = "Output display's details (scale, position, id, etc.).";
    default = {};
    type = lib.types.submodule {
      options = {
        id = lib.mkOption {
          description = "Display's identifier.";
          type = lib.types.str;
        };
        label = lib.mkOption {
          description = "Display's label; arbitrary.";
          type = lib.types.str;
        };
        resolution = lib.mkOption {
          description = "Display's resolution.";
          type = lib.types.submodule {
            options = {
              x = lib.mkOption {
                description = "Display's x-axis pixels.";
                type = lib.types.int;
              };
              y = lib.mkOption {
                description = "Display's y-axis pixels.";
                type = lib.types.int;
              };
            };
          };
        };
        refreshRate = lib.mkOption {
          description = "Display's refresh rate. String, in case mode selection is sensitive.";
          type = lib.types.str;
        };
        variableRefreshRate = lib.mkOption {
          description = "Enable display's VRR mode.";
          type = lib.types.bool;
          default = false;
        };
        scale = lib.mkOption {
          description = "Display's scale factor.";
          type = lib.types.nullOr lib.types.float;
          default = null;
        };
        position = lib.mkOption {
          description = "Display's position.";
          type = lib.types.submodule {
            options = {
              x = lib.mkOption {
                description = "Display's x-axis coordinates.";
                type = lib.types.int;
                default = 0;
              };
              y = lib.mkOption {
                description = "Display's y-axis coordinates.";
                type = lib.types.int;
                default = 0;
              };
            };
          };
        };
        focusAtStartup = lib.mkOption {
          description = "Focus display on startup.";
          type = lib.types.bool;
          default = false;
        };
      };
    };
  };
in {
  options.displays = lib.mkOption {
    description = "Output display information for the host machine.";
    default = {};
    type = lib.types.submodule {
      options = {
        primary = display;
        secondary = display;
      };
    };
  };
}
