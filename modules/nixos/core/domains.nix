{lib, ...}: {
  options.domains = lib.mkOption {
    description = "Domains, keyed by purpose.";
    type = lib.types.attrsOf lib.types.str;
    default = {};
  };

  config.domains = rec {
    personal = "graysn.com";
    root = "ggantek.net";
    lab = "lab.${root}";
  };
}
