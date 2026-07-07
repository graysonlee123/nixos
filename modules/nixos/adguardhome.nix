let
  constants = import ../../data/constants.nix;
in
{
  # openFirewall only opens web UI port, not DNS
  networking.firewall.interfaces."enp2s0".allowedTCPPorts = [ 53 ];
  networking.firewall.interfaces."enp2s0".allowedUDPPorts = [ 53 ];
  networking.nameservers = [ "127.0.0.1" ];
  networking.networkmanager.dns = "none";

  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    openFirewall = true;
    host = "127.0.0.1";
    port = 3000;
    settings = {
      schema_version = 33;
      http = {
        session_ttl = "720h";
      };
      users = [
        {
          name = "gray";
          # bcrypt hash — safe to commit, computationally infeasible to reverse; LAN-only anyway
          password = "$2b$12$ukjUa7ZGWkw4uCYArdaniusYij3WxsRay0ihr8HLDx9cCIAwYvwqK";
        }
      ];
      auth_attempts = 5;
      block_auth_min = 15;
      dns = {
        bind_hosts = [
          constants.hosts.sulaco.ips.lan
          "127.0.0.1"
        ];
        port = 53;
        ratelimit = 300;
        enable_dnssec = true;
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.mullvad.net/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "1.1.1.1"
        ];
        fallback_dns = [
          "https://dns.cloudflare.com/dns-query"
        ];
      };
      querylog = {
        enabled = true;
        interval = "720h";
        size_memory = 1000;
        file_enabled = true;
      };
      statistics = {
        enabled = true;
        interval = "720h";
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt";
          name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
          id = 7;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
          name = "Steven Black's List";
          id = 33;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt";
          name = "HaGeZi's Pro Blocklist";
          id = 48;
        }
      ];
      dhcp.enabled = false;
      tls.enabled = false;
    };
  };
}
