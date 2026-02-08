{ pkgs, ... }:

{
  programs.go.enable = true;
  home.packages = [ pkgs.gopls ];
}

