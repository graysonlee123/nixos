{osConfig, ...}: {
  services.batsignal = {
    enable = osConfig.host.formFactor.type == "laptop";
    extraArgs = [];
  };
}
