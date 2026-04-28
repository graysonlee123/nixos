{
  security.sudo = {
    extraConfig = ''
      Defaults:gray timestamp_timeout=60
      Defaults:gray timestamp_type=global
      Defaults lecture=never
    '';
  };
}
