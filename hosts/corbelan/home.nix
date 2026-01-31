{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/gray.nix 
  ];

  home = {
    additionalPackages = with pkgs; [
      brightnessctl
    ];
  };

  # TODO: restore laptop-specific Sway configuration
}

