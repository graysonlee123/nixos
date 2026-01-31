{
  config = {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;  # 5 seconds
        background-color = "#0a0e0a";
        text-color = "#00ff41";
        border-color = "#00ff41";
        border-size = 2;
        font = "JetBrainsMono Nerd Font 10";
      };
    };
  };
}
