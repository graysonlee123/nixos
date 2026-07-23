let
  hosts = import ./hosts.nix;
  versioning = {
    type = "staggered";
    params = {
      cleanInterval = "3600";
      maxAge = "2592000"; # 30 days
    };
  };
in
rec {
  devices = {
    nostromo = {
      id = "5N4LBAT-Q3W7TMI-4QG2Y66-3HUGMR7-PDL7WBJ-OHOBREZ-5P6LHT5-4BRVSQ7";
      addresses = [
        "tcp://${hosts.nostromo.ips.tailscale}"
      ];
      autoAcceptFolders = true;
    };
    corbelan = {
      id = "LQURRGV-4URVSOT-S2QMDXK-I2KETJD-POFM5CX-4KNHSGR-X2AAV44-5RYCJQJ";
      addresses = [
        "tcp://${hosts.corbelan.ips.tailscale}"
      ];
      autoAcceptFolders = true;
    };
    sulaco = {
      id = "PO7PQ2S-TWO5ETQ-RQBICRW-H6XJHW2-SBYJ4RO-TJAEPWN-XJGZNPR-MQJZVQU";
      addresses = [
        "tcp://${hosts.sulaco.ips.tailscale}"
        "tcp://${hosts.sulaco.ips.lan}"
      ];
      autoAcceptFolders = true;
    };
    iphone = {
      id = "WRRCWDT-PYIB3K3-E2FI3KO-NUXIJ5B-JRRJX6A-N3EQOV7-HCR2KNU-7FSMIAS";
      addresses = [
        "tcp://${hosts.grayson-iphone.ips.tailscale}"
      ];
    };
  };
  folders = {
    Personal = {
      id = "personal";
      devices = builtins.attrNames devices;
      inherit versioning;
    };
    Tarn = {
      id = "tarn";
      devices = builtins.attrNames devices;
      inherit versioning;
    };
    Inspry = {
      id = "inspry";
      devices = (builtins.filter (x: x != "sulaco") (builtins.attrNames devices));
      inherit versioning;
    };
  };
  ignorePatterns = ''
    .git
    node_modules
    vendor
    .next
    .idea
    .vscode
    *.swp
    *.swo
    *~
    .DS_Store
    .Trash-*
    *.tmp
    *.temp
    *.log
  '';
}
