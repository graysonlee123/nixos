{ lib, ... }:

let
  mkSshHost =
    {
      hostname ? null,
      user ? null,
      key,
      keyOnly ? true,
    }:
    {
      identityFile = key;
      identitiesOnly = keyOnly;
    }
    // lib.optionalAttrs (hostname != null) {
      hostname = hostname;
    }
    // lib.optionalAttrs (user != null) {
      user = user;
    };
in
{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        # Personal
        "github.com" = mkSshHost {
          hostname = "github.com";
          user = "git";
          key = "~/.ssh/github";
        };
        # sulaco: home server
        # - remote (Tailscale): ssh sulaco
        # - local network:      ssh sulaco.local
        "sulaco" = mkSshHost {
          hostname = "100.83.63.8";
          user = "grayson";
          key = "~/.ssh/sulaco";
        };
        "sulaco.local" = mkSshHost {
          hostname = "192.168.86.2";
          user = "grayson";
          key = "~/.ssh/sulaco";
        };

        # Inspry
        "inspry.github.com" = mkSshHost {
          hostname = "github.com";
          user = "git";
          key = "~/.ssh/github-inspry";
        };
        "ssh.pressable.com" = mkSshHost {
          key = "~/.ssh/pressable";
        };
        "bitbucket.org" = mkSshHost {
          key = "~/.ssh/bitbucket.org";
        };
        "154.12.120.83" = mkSshHost {
          key = "~/.ssh/bigscoots";
        };
        "3.82.7.41" = mkSshHost {
          key = "~/.ssh/azenco";
        };
        "*.servebolt.cloud" = mkSshHost {
          key = "~/.ssh/servebolt";
        };
        "131.153.238.180" = mkSshHost {
          key = "~/.ssh/rocket.net";
        };
        "ssh.dev.azure.com" = mkSshHost {
          key = "~/.ssh/jti";
        };
      };
    };
  };
}
