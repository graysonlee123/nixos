{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/headless.nix
    ../../users/gray.nix
  ];

  host.name = "sulaco";
  host.staticIP = "192.168.86.2";
  host.networkInterface = "enp2s0";
  system.stateVersion = "25.11";
}
