{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.gameservers;
  gameserverDir = "/var/lib/gameservers";
  getGameserverInstanceDir = game: name: "${gameserverDir}/${game}/${name}";

  # Terraria
  getTerrariaSlug = name: "terraria-${name}";
  getTerrariaPasswordSopsKey = name: "gameservers/terraria/${name}/password";
  getTerrariaDir = name: getGameserverInstanceDir "terraria" name;

  # Minecraft
  getMcSlug = name: "minecraft-${name}";
  getMcBackupsSlug = name: "minecraft-backups-${name}";
  getMcDir = name: getGameserverInstanceDir "minecraft" name;
  getMcRconPasswordSopsKey = name: "gameservers/minecraft/${name}/rcon_password";

  # Pumpkin
  enabledPumpkinServers = lib.filterAttrs (_: srv: srv.enable) cfg.pumpkin;
  hasPumpkinServers = enabledPumpkinServers != { };
  getPumpkinSlug = name: "pumpkin-${name}";
  getPumpkinStateDir = name: "gameservers/pumpkin/${name}";
  pumpkinBinary = pkgs.pumpkin-server; # source build pinned via the `pumpkin` flake input
  tomlFormat = pkgs.formats.toml { };

  # Player = { name, uuid }. UUID is the immutable match key; resolve names to
  # UUIDs at build time (see data/minecraft-players.nix) so the server never
  # depends on the Mojang API at boot.
  playerType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        description = "Player username (cosmetic; may go stale).";
        type = lib.types.str;
      };
      uuid = lib.mkOption {
        description = "Dashed Mojang UUID.";
        type = lib.types.str;
      };
    };
  };
in
{
  options.services.gameservers = {
    terraria = lib.options.mkOption {
      description = "Terraria servers to run within Docker.";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Terraria server";
            port = lib.mkOption {
              description = "Host container port.";
              type = lib.types.port;
              default = 7777;
            };
          };
        }
      );
    };

    minecraft = lib.options.mkOption {
      description = "Minecraft servers to run within Docker.";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Minecraft server";
            port = lib.mkOption {
              description = "Host container port.";
              type = lib.types.port;
              default = 25565;
            };
            memory = lib.mkOption {
              description = "Memory to allocate.";
              type = lib.types.str;
              default = "2G";
            };
            version = lib.mkOption {
              description = "Version of Minecraft to run.";
              type = lib.types.str;
            };
            type = lib.mkOption {
              description = "Server type.";
              type = lib.types.enum [
                "vanilla"
                "fabric"
              ];
              default = "vanilla";
            };
            difficulty = lib.mkOption {
              description = "Difficulty of the world.";
              type = lib.types.enum [
                "peaceful"
                "easy"
                "normal"
                "hard"
              ];
              default = "easy";
            };
            seed = lib.mkOption {
              description = "World seed.";
              type = lib.types.str;
            };
            motd = lib.mkOption {
              description = "Message of the day.";
              type = lib.types.str;
              default = "";
            };
            icon = lib.mkOption {
              description = "Server icon.";
              type = lib.types.str;
              default = "";
            };
            ops = lib.mkOption {
              description = "Operator player usernames.";
              type = lib.types.listOf lib.types.str;
              default = [ "pizzaThis" ];
            };
            whitelist = lib.mkOption {
              description = "Whitelisted player usernames.";
              type = lib.types.listOf lib.types.str;
              default = [ "pizzaThis" ];
            };
            modrinth = {
              projects = lib.mkOption {
                description = "Modrinth project slugs to install.";
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
          };
        }
      );
    };

    pumpkin = lib.mkOption {
      description = "Pumpkin Minecraft servers running as native systemd services.";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Pumpkin server";
            port = lib.mkOption {
              description = "Server port.";
              type = lib.types.port;
              default = 25565;
            };
            seed = lib.mkOption {
              description = "World seed.";
              type = lib.types.str;
              default = "";
            };
            difficulty = lib.mkOption {
              description = "Difficulty.";
              type = lib.types.enum [
                "Peaceful"
                "Easy"
                "Normal"
                "Hard"
              ];
              default = "Normal";
            };
            gamemode = lib.mkOption {
              description = "Default gamemode.";
              type = lib.types.enum [
                "Survival"
                "Creative"
                "Adventure"
                "Spectator"
              ];
              default = "Survival";
            };
            motd = lib.mkOption {
              description = "Message of the day.";
              type = lib.types.str;
              default = "A Pumpkin server";
            };
            maxPlayers = lib.mkOption {
              description = "Max players.";
              type = lib.types.int;
              default = 20;
            };
            viewDistance = lib.mkOption {
              description = "View distance in chunks.";
              type = lib.types.int;
              default = 16;
            };
            simulationDistance = lib.mkOption {
              description = "Simulation distance in chunks.";
              type = lib.types.int;
              default = 10;
            };
            ops = lib.mkOption {
              description = "Operator players ({ name, uuid }).";
              type = lib.types.listOf playerType;
              default = [ ];
            };
            whitelist = lib.mkOption {
              description = "Whitelisted players ({ name, uuid }).";
              type = lib.types.listOf playerType;
              default = [ ];
            };
          };
        }
      );
    };
  };

  config = {
    virtualisation.oci-containers.containers = lib.mkMerge [
      # Terraria
      (lib.mapAttrs' (
        name: srv:
        let
          slug = getTerrariaSlug name;
          passwordPath = config.sops.secrets.${getTerrariaPasswordSopsKey name}.path;
        in
        lib.nameValuePair slug {
          image = "ryshe/terraria@sha256:55539b1d972159109875c1ba8bda221b718983a8fd4726e6ff8249a026233fd5";
          entrypoint = "/bin/sh";
          cmd = [
            "-c"
            ''exec /terraria-server/bootstrap.sh -password "$(tr -d '\n' < ${passwordPath})"''
          ];
          volumes = [
            "${getTerrariaDir name}:/root/.local/share/Terraria/Worlds"
            "${passwordPath}:${passwordPath}"
          ];
          ports = [ "${toString srv.port}:7777" ];
          environment = {
            "WORLD_FILENAME" = "${name}.wld";
          };
        }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.terraria))

      # Minecraft
      (lib.mapAttrs' (
        name: srv:
        let
          slug = getMcSlug name;
          hostDir = "${getMcDir name}";
          rconPassword = {
            hostPath = config.sops.secrets.${getMcRconPasswordSopsKey name}.path;
            containerPath = "/rcon-password";
          };
        in
        lib.nameValuePair slug {
          image = "itzg/minecraft-server@sha256:ca02da99646d1d670a591f0694c683b8e81224d27e8430bd058db435a0939382";
          extraOptions = [
            # "--tty"
            "--interactive"
          ];
          hostname = slug;
          ports = [ "${toString srv.port}:25565" ];
          volumes = [
            "${hostDir}/data:/data"
            "${rconPassword.hostPath}:${rconPassword.containerPath}:ro"
          ];
          environment = {
            TZ = "America/New_York";
            MEMORY = srv.memory;
            EULA = "true";
            VERSION = srv.version;
            TYPE = srv.type;
            DIFFICULTY = srv.difficulty;
            SEED = srv.seed;
            SERVER_NAME = "Minecraft (${name})";
            MOTD = srv.motd;
            ALLOW_FLIGHT = "true";
            ICON = srv.icon;
            PAUSE_WHEN_EMPTY_SECONDS = "600";
            RCON_PASSWORD_FILE = rconPassword.containerPath;
            WHITELIST = lib.concatStringsSep "\n" srv.whitelist;
            OPS = lib.concatStringsSep "\n" srv.ops;
            MODRINTH_PROJECTS = lib.concatStringsSep "\n" srv.modrinth.projects;
            MODRINTH_DOWNLOAD_DEPENDENCIES = "required";
          };
        }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.minecraft))

      # Minecraft Backups
      (lib.mapAttrs' (
        name: srv:
        let
          slug = getMcBackupsSlug name;
          gameServerSlug = getMcSlug name;
          hostDir = "${getMcDir name}";
          rconPassword = {
            hostPath = config.sops.secrets.${getMcRconPasswordSopsKey name}.path;
            containerPath = "/rcon-password";
          };
        in
        lib.nameValuePair slug {
          image = "itzg/mc-backup@sha256:5d2c1fb80f4a225927e6ff05305d915ee2866bc320dd999f23373360cf88bd40";
          dependsOn = [ gameServerSlug ];
          extraOptions = [ "--network=container:${gameServerSlug}" ];
          volumes = [
            "${hostDir}/data:/data:ro"
            "${hostDir}/backups:/backups"
            "${rconPassword.hostPath}:${rconPassword.containerPath}:ro"
          ];
          environment = {
            TZ = "America/New_York";
            BACKUP_INTERVAL = "2h";
            PAUSE_IF_NO_PLAYERS = "true";
            RCON_HOST = gameServerSlug;
            RCON_PASSWORD_FILE = rconPassword.containerPath;
          };
        }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.minecraft))
    ];

    # Pumpkin systemd services
    systemd.services = lib.mapAttrs' (
      name: srv:
      let
        slug = getPumpkinSlug name;
        stateDir = getPumpkinStateDir name;
        configFile = tomlFormat.generate "pumpkin.toml" {
          seed = srv.seed;
          default_difficulty = srv.difficulty;
          default_gamemode = srv.gamemode;
          white_list = srv.whitelist != [ ];
          enforce_whitelist = srv.whitelist != [ ];
          commands = {
            use_tty = false;
          };
          networking.java = {
            address = "0.0.0.0:${toString srv.port}";
            max_players = srv.maxPlayers;
            view_distance = srv.viewDistance;
            simulation_distance = srv.simulationDistance;
            motd = srv.motd;
          };
        };
        whitelistJson = pkgs.writeText "pumpkin-${name}-whitelist.json" (
          builtins.toJSON (map (p: { inherit (p) uuid name; }) srv.whitelist)
        );
        opsJson = pkgs.writeText "pumpkin-${name}-ops.json" (
          builtins.toJSON (
            map (p: {
              inherit (p) uuid name;
              level = 4;
              bypasses_player_limit = false;
            }) srv.ops
          )
        );
        # pumpkin.toml sits at the working-dir root; whitelist.json/ops.json
        # live in the data/ subdir (alongside Pumpkin's banned-*.json).
        setupScript = pkgs.writeShellScript "pumpkin-${name}-setup" ''
          # Copies land read-only from the store; make them writable so Pumpkin
          # can manage them at runtime (changes reset to config on restart).
          install -m644 ${configFile} pumpkin.toml
          mkdir -p data
          install -m644 ${whitelistJson} data/whitelist.json
          install -m644 ${opsJson} data/ops.json
        '';
      in
      lib.nameValuePair slug {
        description = "Pumpkin Minecraft server (${name})";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStartPre = setupScript;
          ExecStart = "${pumpkinBinary}/bin/pumpkin";
          WorkingDirectory = "/var/lib/${stateDir}";
          StateDirectory = stateDir;
          Restart = "on-failure";
          RestartSec = 10;
          User = "pumpkin";
          Group = "pumpkin";
        };
      }
    ) enabledPumpkinServers;

    users.users.pumpkin = lib.mkIf hasPumpkinServers {
      isSystemUser = true;
      group = "pumpkin";
    };
    users.groups.pumpkin = lib.mkIf hasPumpkinServers { };

    networking.firewall.allowedTCPPorts = lib.pipe enabledPumpkinServers [
      (lib.mapAttrsToList (_: srv: srv.port))
    ];

    sops.secrets = lib.mkMerge [
      (lib.mapAttrs' (name: srv: lib.nameValuePair (getTerrariaPasswordSopsKey name) { }) (
        lib.filterAttrs (_: srv: srv.enable) cfg.terraria
      ))

      (lib.mapAttrs' (
        name: srv:
        lib.nameValuePair (getMcRconPasswordSopsKey name) {
          mode = "0444"; # Container runs as user 1000; secret is mounted as root
        }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.minecraft))
    ];
  };
}
