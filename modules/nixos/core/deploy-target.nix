# Lets colmena push to and activate on this host as gray (non-root SSH).
{
  # Accept unsigned store paths copied by gray.
  nix.settings.trusted-users = ["gray"];
  # Colmena runs activation via non-interactive sudo.
  security.sudo.wheelNeedsPassword = false;
}
