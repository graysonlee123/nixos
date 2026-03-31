{ lib, ... }: {
  services.fprintd.enable = true;
  services.greetd.enable = lib.mkForce false;
  services.displayManager.ly.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    ly.fprintAuth = true;
  };
}
