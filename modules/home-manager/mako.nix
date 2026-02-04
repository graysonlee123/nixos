{
  config = {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;  # 5 seconds
        border-size = 2;
      };
    };
  };
}
