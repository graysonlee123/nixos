{pkgs, ...}: let
  version = "7.1.3";
  wpSrc = pkgs.fetchzip {
    url = "https://wordpress.org/wordpress-${version}.tar.gz";
    hash = "sha256-7jj+sDJv5ekfeP7AJ/XUG7n+cBPYcPqoH+UTt9hePS0=";
  };
in {
  home.file."src/wordpress".source = wpSrc;
}
