{
  pkgs,
  pkgs-unstable,
  lib,
  osConfig,
  config,
  ...
}: let
  flakePath = "${config.home.homeDirectory}/repos/me/nixos";
  hostName = osConfig.networking.hostName;
in {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        extensions = with pkgs; [
          vscode-extensions.aaron-bond.better-comments
          vscode-extensions.oderwat.indent-rainbow
          vscode-extensions.mikestead.dotenv
          vscode-extensions.esbenp.prettier-vscode
          vscode-extensions.prisma.prisma
          vscode-extensions.astro-build.astro-vscode
          vscode-extensions.unifiedjs.vscode-mdx
          vscode-extensions.golang.go
          vscode-extensions.jnoortheen.nix-ide
          vscode-extensions.biomejs.biome
          vscode-extensions.bradlc.vscode-tailwindcss
        ];
        userSettings = {
          "update.mode" = "none";
          "workbench.startupEditor" = "readme";
          "workbench.activityBar.location" = "top";
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          "security.workspace.trust.enabled" = false;
          "editor.renderWhitespace" = "all";
          "editor.minimap.enabled" = false;
          "editor.acceptSuggestionOnCommitCharacter" = false;
          "explorer.compactFolders" = false;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "html.autoCreateQuotes" = false;
          "html.format.indentInnerHtml" = true;
          "[go]" = {
            "editor.defaultFormatter" = "golang.go";
          };
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = ["alejandra"];
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.${hostName}.options";
                };
                "home-manager" = {
                  "expr" = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.${hostName}.options.home-manager.users.type.getSubOptions []";
                };
              };
            };
          };
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          "extensions.ignoreRecommendations" = true;
          "biome.lsp.bin" = "${pkgs-unstable.biome}/bin/biome";
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "chat.disableAIFeatures" = true;
          "json.schemaDownload.trustedDomains" = lib.genAttrs [
            "https://schemastore.azurewebsites.net/"
            "https://raw.githubusercontent.com/microsoft/vscode/"
            "https://raw.githubusercontent.com/devcontainers/spec/"
            "https://www.schemastore.org/"
            "https://json.schemastore.org/"
            "https://json-schema.org/"
            "https://developer.microsoft.com/json-schemas/"
            "https://biomejs.dev"
            "https://turbo.build/schema.json"
          ] (_: true);
        };
        keybindings = [
          {
            key = "alt+f5";
            command = "workbench.action.debug.selectandstart";
          }
        ];
      };
    };
  };
}
