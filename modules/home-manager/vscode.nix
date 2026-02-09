{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
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
          "[go]" = { "editor.defaultFormatter" = "golang.go"; };
          "[nix]" = { "editor.defaultFormatter" = "jnoortheen.nix-ide"; };
        };
        keybindings = [];
      };
    };
  };
}

