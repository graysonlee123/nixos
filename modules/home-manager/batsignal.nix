{ isLaptop, ... }:
{
  config = {
    services.batsignal = {
      enable = isLaptop;
      extraArgs = [ ];
    };
  };
}
