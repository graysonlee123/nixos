{lib, ...}: {
  options.host.formFactor.type = lib.mkOption {
    description = "Host form factor, set per host. `server` is headless and selects the headless HM profile.";
    type = lib.types.enum ["desktop" "laptop" "server"];
  };
}
