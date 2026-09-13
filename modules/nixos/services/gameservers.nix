{
  config,
  lib,
  ...
}: let
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

  # Valheim
  getValheimSlug = name: "valheim-${name}";
  getValheimDir = name: getGameserverInstanceDir "valheim" name;
  getValheimPasswordSopsKey = name: "gameservers/valheim/${name}/password";
  getValheimEnvTemplate = name: "valheim-${name}.env";
in {
  options.services.gameservers = {
    terraria = lib.options.mkOption {
      description = "Terraria servers to run within Docker.";
      default = {};
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
      default = {};
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
              default = ["pizzaThis"];
            };
            whitelist = lib.mkOption {
              description = "Whitelisted player usernames.";
              type = lib.types.listOf lib.types.str;
              default = ["pizzaThis"];
            };
            modrinth = {
              projects = lib.mkOption {
                description = "Modrinth project slugs to install.";
                type = lib.types.listOf lib.types.str;
                default = [];
              };
            };
            packwiz = {
              url = lib.mkOption {
                description = "URL to a packwiz pack.toml. Installs/updates the modpack on each start.";
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
            };
          };
        }
      );
    };

    valheim = lib.options.mkOption {
      description = "Valheim servers to run within Docker.";
      default = {};
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Valheim server";
            port = lib.mkOption {
              description = "Host UDP port; server also uses port+1 for queries.";
              type = lib.types.port;
              default = 2456;
            };
            serverName = lib.mkOption {
              description = "Server name shown in the browser.";
              type = lib.types.str;
            };
            world = lib.mkOption {
              description = "World name. Defaults to the instance name.";
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            valheimPlus = lib.mkOption {
              description = "Whether or not to enable Valheim+ with opinionated configuration.";
              type = lib.types.bool;
              default = false;
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
        name: srv: let
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
            ports = ["${toString srv.port}:7777"];
            environment = {
              "WORLD_FILENAME" = "${name}.wld";
            };
          }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.terraria))

      # Minecraft
      (lib.mapAttrs' (
        name: srv: let
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
            ports = ["${toString srv.port}:25565"];
            volumes = [
              "${hostDir}/data:/data"
              "${rconPassword.hostPath}:${rconPassword.containerPath}:ro"
            ];
            environment =
              {
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
              }
              // lib.optionalAttrs (srv.packwiz.url != null) {
                PACKWIZ_URL = srv.packwiz.url;
              };
          }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.minecraft))

      # Minecraft Backups
      (lib.mapAttrs' (
        name: srv: let
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
            dependsOn = [gameServerSlug];
            extraOptions = ["--network=container:${gameServerSlug}"];
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

      # Valheim
      (lib.mapAttrs' (
        name: srv: let
          slug = getValheimSlug name;
          hostDir = getValheimDir name;
        in
          lib.nameValuePair slug {
            image = "lloesche/valheim-server@sha256:bbda47cbbc9fd7b0385803ba0a70ba2084df4cb87ec6170a145aec5df06be07e";
            hostname = slug;
            ports = [
              "${toString srv.port}:2456/udp"
              "${toString (srv.port + 1)}:2457/udp"
            ];
            volumes = [
              "${hostDir}/config:/config"
              "${hostDir}/server:/opt/valheim"
            ];
            environmentFiles = [
              config.sops.templates.${getValheimEnvTemplate name}.path
            ];
            environment =
              {
                TZ = "America/New_York";
                SERVER_NAME = srv.serverName;
                WORLD_NAME =
                  if srv.world == null
                  then name
                  else srv.world;
                SERVER_PORT = "2456"; # Container-internal port; host port set via `ports`
                SERVER_PUBLIC = "0"; # Never list in public browser; join via direct IP + pass
                BACKUPS_MAX_AGE = "7"; # Days of backups to keep
                PUID = "1000";
                PGID = "1000";
              }
              // lib.optionalAttrs (srv.valheimPlus) {
                # Valheim Plus
                # Configuration reference: https://github.com/Grantapher/ValheimPlus/blob/main/valheim_plus.cfg
                VALHEIM_PLUS = "true";
                VPCFG_ValheimPlus_serverBrowserAdvertisement = "false";

                # Bed configuration
                VPCFG_Bed_enabled = "true";
                VPCFG_Bed_sleepWithoutSpawn = "true";

                # Camera
                VPCFG_Camera_enabled = "true";
                VPCFG_Camera_cameraMaximumZoomDistance = "12";
                VPCFG_Camera_cameraBoatMaximumZoomDistance = "24";

                # Fermenter
                VPCFG_Fermenter_enabled = "true";
                VPCFG_Fermenter_showDuration = "true";

                # Fire Source configuration
                VPCFG_FireSource_enabled = "true";
                VPCFG_FireSource_torches = "true";

                # Game
                VPCFG_Game_enabled = "true";
                VPCFG_Game_bigPortalNames = "true";

                # Items configuration
                VPCFG_Items_enabled = "true";
                VPCFG_Items_noTeleportPrevention = "true";
                VPCFG_Items_baseItemWeightReduction = "-90";
                VPCFG_Items_itemStackMultiplier = "1000";
                VPCFG_Items_droppedItemOnGroundDurationInSeconds = "${toString (3600 * 6)}";

                # HUD configuration
                VPCFG_Hud_enabled = "true";
                VPCFG_Hud_experienceGainedNotifications = "true";

                # Map configuration
                VPCFG_Map_enabled = "true";
                VPCFG_Map_shareMapProgression = "true";
                VPCFG_Map_shareAllPins = "true";
                VPCFG_Map_displayCartsAndBoats = "true";

                # Player configuration
                VPCFG_Player_enabled = "true";
                VPCFG_Player_baseMaximumWeight = "1337";
                VPCFG_Player_disableEncumbered = "true";
                VPCFG_Player_autoPickUpWhenEncumbered = "true";

                # Server configuration
                VPCFG_Server_enabled = "true";
                VPCFG_Server_enforceMod = "true";
                VPCFG_Server_serverSyncsConfig = "true";
                VPCFG_Server_maxPlayers = "2";
                VPCFG_Server_disableServerPassword = "true";

                # Structural Integrity configuration
                VPCFG_StructuralIntegrity_enabled = "true";
                VPCFG_StructuralIntegrity_wood = "100";
                VPCFG_StructuralIntegrity_stone = "100";
                VPCFG_StructuralIntegrity_iron = "100";
                VPCFG_StructuralIntegrity_hardWood = "100";
                VPCFG_StructuralIntegrity_marble = "100";
                VPCFG_StructuralIntegrity_ashstone = "100";
                VPCFG_StructuralIntegrity_ancient = "100";

                # Inventory configuration
                VPCFG_Inventory_enabled = "true";
                VPCFG_Inventory_playerInventoryRows = "6";
                VPCFG_Inventory_woodChestRows = "3";
                VPCFG_Inventory_woodChestColumns = "6";
                VPCFG_Inventory_ironChestRows = "5";
                VPCFG_Inventory_ironChestColumns = "7";
                VPCFG_Inventory_blackmetalChestRows = "6";
                VPCFG_Inventory_blackmetalChestColumns = "8"; # Max
                VPCFG_Inventory_karveInventoryRows = "3";
                VPCFG_Inventory_karveInventoryColumns = "3";
                VPCFG_Inventory_longboatInventoryRows = "4";
                VPCFG_Inventory_longboatInventoryColumns = "8"; # Max
                VPCFG_Inventory_inventoryFillTopToBottom = "true";
                VPCFG_Inventory_mergeWithExistingStacks = "true";

                # Ship
                VPCFG_Ship_enabled = "true";
                VPCFG_Ship_forwardSpeed = "50";
                VPCFG_Ship_backwardSpeed = "50";
                VPCFG_Ship_rudderSpeed = "50";
                VPCFG_Ship_steerForce = "50";
                VPCFG_Ship_waterImpactDamage = "-50";

                # Workbench
                VPCFG_Workbench_enabled = "true";
                VPCFG_Workbench_workbenchAttachmentRange = "10";
                VPCFG_Workbench_disableRoofCheck = "true";

                # GameClock
                VPCFG_GameClock_enable = "true";
                VPCFG_GameClock_useAMPM = "true";
              };
          }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.valheim))
    ];

    sops.secrets = lib.mkMerge [
      (lib.mapAttrs' (name: srv: lib.nameValuePair (getTerrariaPasswordSopsKey name) {}) (
        lib.filterAttrs (_: srv: srv.enable) cfg.terraria
      ))

      (lib.mapAttrs' (
        name: srv:
          lib.nameValuePair (getMcRconPasswordSopsKey name) {
            mode = "0444"; # Container runs as user 1000; secret is mounted as root
          }
      ) (lib.filterAttrs (_: srv: srv.enable) cfg.minecraft))

      (lib.mapAttrs' (name: srv: lib.nameValuePair (getValheimPasswordSopsKey name) {}) (
        lib.filterAttrs (_: srv: srv.enable) cfg.valheim
      ))
    ];

    # Render the Valheim password into an env file; SERVER_PASS has no *_FILE variant.
    sops.templates = lib.mapAttrs' (
      name: srv:
        lib.nameValuePair (getValheimEnvTemplate name) {
          content = "SERVER_PASS=${config.sops.placeholder.${getValheimPasswordSopsKey name}}";
        }
    ) (lib.filterAttrs (_: srv: srv.enable) cfg.valheim);
  };
}
