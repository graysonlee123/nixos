{lib, ...}: {
  # Stylix uses light adw-gtk3 + recolor; unrecolored bits (dialog button
  # labels) keep light-theme dark text. Dark variant fixes them.
  gtk.theme.name = lib.mkForce "adw-gtk3-dark";
}
