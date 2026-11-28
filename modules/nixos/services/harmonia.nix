{
  config,
  lib,
  ...
}: let
  port = 5839;
  # Peers running Harmonia: NixOS, not this host, signing key known
  peers = lib.filterAttrs (n: h: h.isNixOS && h.harmoniaPubKey != null && n != config.host.name) config.lan.hosts;
  # Lower = preferred. cache.nixos.org is 40, so peers win.
  priorities = {
    sulaco = 10;
    nostromo = 20;
    corbelan = 50;
  };
in {
  services.harmonia.cache = {
    enable = true;
    settings = {
      bind = "[::]:${toString port}";
    };
    # Per-host key, only this host can decrypt it
    signKeyPaths = [config.sops.secrets."harmonia/sign-key".path];
  };

  sops.secrets."harmonia/sign-key" = {sopsFile = ../../../secrets/hosts/${config.host.name}.yaml;};

  # Only reachable over Tailscale
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [port];

  nix.settings = {
    substituters =
      lib.mapAttrsToList (
        n: v: "http://${v.ips.tailscale}:${toString port}?priority=${toString (priorities.${n} or 35)}"
      )
      peers;
    trusted-public-keys = lib.mapAttrsToList (_: h: h.harmoniaPubKey) peers;
    # Offline peers (e.g. sleeping laptop) fail fast, fall back to next substituter
    connect-timeout = 3;
    fallback = true;
  };
}
