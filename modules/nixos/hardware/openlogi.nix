{
  # OpenLogi: local-first manager for Logitech HID++ peripherals.
  # Module (options + package) comes from the openlogi flake input,
  # imported in flake.nix mkHost. Package pulls its own nixpkgs-unstable
  # + rust-overlay toolchain.
  programs.openlogi = {
    enable = true;
    launchAtLogin = true;
  };
}
