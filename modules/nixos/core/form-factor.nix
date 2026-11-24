{lib, ...}: {
  options.host.formFactor = {
    isHeadless = lib.mkOption {
      description = "Whether host has no GUI. Selects headless HM profile. Set by `profiles/headless.nix`.";
      type = lib.types.bool;
      default = false;
    };
    isLaptop = lib.mkOption {
      description = "Whether host is a laptop (battery, backlight, built-in display).";
      type = lib.types.bool;
      default = false;
    };
  };
}
