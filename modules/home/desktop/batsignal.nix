{osConfig, ...}: {
  services.batsignal = {
    enable = osConfig.host.formFactor.isLaptop;
    extraArgs = [];
  };
}
