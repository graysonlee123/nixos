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
        includeCoAuthoredBy = false;
        model = "claude-sonnet-4-6";
        extraKnownMarketplaces = {
          caveman = {
            source = {
              source = "github";
              repo = "JuliusBrussee/caveman";
            };
          };
        };
        enabledPlugins = {
          "gopls-lsp@claude-plugins-official" = true;
          "typescript-lsp@claude-plugins-official" = true;
          "caveman@caveman" = true;
        };
        cleanupPeriodDays = 30;
        statusLine = {
          type = "command";
          command = "~/.claude/statusline.sh";
        };
        permissions = {
          allow = [
            # Bash
            "Bash(npm run build)"
            "Bash(npm run build:*)"
            "Bash(pnpm run build)"
            "Bash(pnpm run build:*)"
            "Bash(gh issue list:*)"
            "Bash(gh issue status:*)"
            "Bash(gh issue view:*)"
            "Bash(gh pr list:*)"
            "Bash(gh pr status:*)"
            "Bash(gh pr diff:*)"
            "Bash(gh pr view:*)"
            "Bash(git log:*)"
            "Bash(git status:*)"
            "Bash(git diff:*)"
            "Bash(git show:*)"
            "Bash(git branch:*)"
            "Bash(git blame:*)"
            "Bash(git stash list:*)"
            "Bash(git remote:*)"
            "Bash(date:*)"
            "Bash(which:*)"
            "Bash(ls:*)"
            "Bash(pwd:*)"
            "Bash(wc:*)"

            # ClickUp
            "mcp__clickup__clickup_get_*"
            "mcp__clickup__clickup_list_*"
            "mcp__clickup__clickup_filter_tasks"
            "mcp__clickup__clickup_find_member_by_name"
            "mcp__clickup__clickup_search"
          ];
        };
      };
      memory.text = ''
        - In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.
        - At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise and sacrifice grammar for the sake of consision.
        - Besides the expected ones, binaries I have installed that may be useful to you include tree, docker, ripgrep, zip, unzip, wl-copy, wl-paste, and wp-cli.
        - Don't use em dashes in write-ups intended for clients.
      '';
      mcpServers = {
        clickup = {
          url = "https://mcp.clickup.com/mcp";
          type = "http";
        };
      };
      skills = {
        wordpress-source-code = ../../claude/skills/wordpress-source-code;
        woocommerce-source-code = ../../claude/skills/woocommerce-source-code;
      };
    };
  };
}
