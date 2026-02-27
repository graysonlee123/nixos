{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      curl
      file
      inxi
    ];
  };
}
