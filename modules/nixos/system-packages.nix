{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      curl
      file
      inxi
      mangohud
      openvpn
      age
      sops
    ];
  };
}
