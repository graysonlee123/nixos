{
  config,
  lib,
  ...
}: let
  dnsPort = 53;
  mkClient = {
    name,
    ids,
    uuid,
  }: {
    inherit name ids uuid;
    safe_search = {
      enabled = false;
      bing = true;
      duckduckgo = true;
      ecosia = true;
      google = true;
      pixabay = true;
      yandex = true;
      youtube = true;
    };
    blocked_services = {
      ids = [];
      schedule.time_zone = "Local";
    };
    tags = [];
    upstreams = [];
    upstreams_cache_size = 0;
    upstreams_cache_enabled = false;
    use_global_settings = true;
    filtering_enabled = false;
    parental_enabled = false;
    safebrowsing_enabled = false;
    use_global_blocked_services = true;
    ignore_querylog = false;
    ignore_statistics = false;
  };
in {
  # openFirewall only opens web UI port, not DNS/DHCP
  networking.firewall.interfaces.${config.host.networkInterface} = {
    allowedTCPPorts = [
      dnsPort # DNS
    ];
    allowedUDPPorts = [
      dnsPort # DNS
      67 # DHCP
      68 # DHCP
    ];
  };

  # Fallback keeps sulaco resolving (rollbacks, rebuilds) if AdGuard dies
  networking.nameservers = ["127.0.0.1" "9.9.9.9"];
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
          config.lan.hosts.sulaco.ips.lan
          "127.0.0.1"
        ];
        port = dnsPort;
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
      dhcp = {
        enabled = true;
        interface_name = "enp2s0";
        dhcpv4 = {
          gateway_ip = config.lan.gateway;
          subnet_mask = config.lan.subnetMask;
          range_start = config.lan.rangeStart;
          range_end = config.lan.rangeEnd;
          lease_duration = 0; # 24-hour default
          local_domain_name = "lan";
        };
      };
      # MAC identifiers don't aggregate in client stats: https://github.com/AdguardTeam/AdGuardHome/issues/4649
      clients.persistent = (
        lib.mapAttrsToList (
          _: value: (mkClient {
            name = value.label;
            ids = [value.mac];
            uuid = value.uuid;
          })
        )
        config.lan.hosts
      );
      tls.enabled = false;
    };
  };
}
