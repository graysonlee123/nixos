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

  home.isLaptop = true;
}

