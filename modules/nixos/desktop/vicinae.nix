{pkgs, ...}: {
  # Vicinae's input server monitors keyboards (/dev/input/event*) for snippet
  # expansion and injects keys via /dev/uinput. Upstream setcaps the binary
  # post-install; store paths can't carry caps, so wrap it like upstream's
  # nix/nixos-module.nix. HM vicinae module points VICINAE_INPUT_SERVER_BIN here.
  security.wrappers.vicinae-input-server = {
    source = "${pkgs.vicinae}/libexec/vicinae/vicinae-input-server";
    capabilities = "cap_dac_override+ep";
    owner = "root";
    group = "root";
  };
}
