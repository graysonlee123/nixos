{
  emails = {
    gmail = "graysonleegantek@gmail.com";
    personal = "hello@graysn.com";
    work = "grayson@inspry.com";
  };
  hosts = {
    sulaco.ips = {
      lan = "192.168.86.2";
      tailscale = "100.93.40.89";
    };
    nostromo.ips = {
      tailscale = "100.73.78.2";
    };
    corbelan.ips = {
      tailscale = "100.75.203.122";
    };
  };
  network = {
    gateway = "192.168.86.1";
    dockerBridge = "172.17.0.1";
    dockerSubnet = "172.17.0.0/16";
    dns = [ "192.168.86.1" ];
  };
}
