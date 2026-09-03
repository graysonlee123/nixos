{isLaptop, ...}: {
  services.batsignal = {
    enable = isLaptop;
    extraArgs = [];
  };
}
