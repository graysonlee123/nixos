{
  programs.hyprland.enable = true;

  # hyprlock authenticates through PAM; without this service it can't unlock.
  security.pam.services.hyprlock = {};
}
