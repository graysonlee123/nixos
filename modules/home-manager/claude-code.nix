{ pkgs-unstable, ... }:

{
  config = {
    home.file.".claude/statusline.sh" = {
      source = ../../scripts/claude-statusline.sh;
      executable = true;
    };

    programs.claude-code = {
      enable = true;
      package = pkgs-unstable.claude-code;
      settings = {
        enabledPlugins = {
          "gopls-lsp@claude-plugins-official" = true;
          "typescript-lsp@claude-plugins-official" = true;
        };
        cleanupPeriodDays = 30;
        statusLine = {
          type = "command";
          command = "~/.claude/statusline.sh";
        };
        permissions = {
          allow = [
            "Bash(npm run build)"
            "Bash(npm run build:*)"
            "Bash(pnpm run build)"
            "Bash(pnpm run build:*)"
          ];
        };
      };
      memory.text = ''
        - In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.
        - At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise and sacrifice grammar for the sake of consision.
        - Besides the expected ones, binaries I have installed that may be useful to you include tree, docker, ripgrep, zip, unzip, wl-copy, wl-paste, and wp-cli.
      '';
    };
  };
}
