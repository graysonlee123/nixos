{...}: {
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.greetd.fprintAuth = false;
  security.pam.services.hyprlock.fprintAuth = false;
}
