{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };
    extraConfig = ''
      set number
      set autoindent
      set smartindent
    '';
  };
}
