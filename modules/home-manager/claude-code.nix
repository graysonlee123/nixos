{
  pkgs,
  pkgs-unstable,
  lib,
  isHeadless,
  ...
}:

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
        model = "claude-opus-4-6";
        effortLevel = "high";
        extraKnownMarketplaces = {
          caveman = {
            source = {
              source = "github";
              repo = "JuliusBrussee/caveman";
            };
          };
        };
        enabledPlugins = {
          "caveman@caveman" = true;
        }
        // lib.optionalAttrs (!isHeadless) {
          "gopls-lsp@claude-plugins-official" = true;
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
            "Bash(rg:*)"
          ]
          ++ lib.optionals (!isHeadless) [
            # ClickUp (read-only)
            "mcp__clickup__clickup_filter_tasks"
            "mcp__clickup__clickup_find_member_by_name"
            "mcp__clickup__clickup_get_bulk_tasks_time_in_status"
            "mcp__clickup__clickup_get_chat_channel_messages"
            "mcp__clickup__clickup_get_chat_channels"
            "mcp__clickup__clickup_get_chat_message_replies"
            "mcp__clickup__clickup_get_current_time_entry"
            "mcp__clickup__clickup_get_custom_fields"
            "mcp__clickup__clickup_get_document_pages"
            "mcp__clickup__clickup_get_folder"
            "mcp__clickup__clickup_get_list"
            "mcp__clickup__clickup_get_task"
            "mcp__clickup__clickup_get_task_comments"
            "mcp__clickup__clickup_get_task_time_in_status"
            "mcp__clickup__clickup_get_threaded_comments"
            "mcp__clickup__clickup_get_time_entries"
            "mcp__clickup__clickup_get_workspace_hierarchy"
            "mcp__clickup__clickup_get_workspace_members"
            "mcp__clickup__clickup_list_document_pages"
            "mcp__clickup__clickup_download_task_attachment"
            "mcp__clickup__clickup_resolve_assignees"
            "mcp__clickup__clickup_search"
            "mcp__clickup__clickup_search_reminders"
            # JetBrains (read-only)
            "mcp__jetbrains__find_files_by_glob"
            "mcp__jetbrains__find_files_by_name_keyword"
            "mcp__jetbrains__get_all_open_file_paths"
            "mcp__jetbrains__get_file_problems"
            "mcp__jetbrains__get_file_text_by_path"
            "mcp__jetbrains__get_project_dependencies"
            "mcp__jetbrains__get_project_modules"
            "mcp__jetbrains__get_repositories"
            "mcp__jetbrains__get_run_configurations"
            "mcp__jetbrains__get_symbol_info"
            "mcp__jetbrains__list_directory_tree"
            "mcp__jetbrains__search_in_files_by_regex"
            "mcp__jetbrains__reformat_file"
            "mcp__jetbrains__rename_refactoring"
            "mcp__jetbrains__search_in_files_by_text"
          ];
        };
      };
      memory.text = ''
        - In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.
        - At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise and sacrifice grammar for the sake of consision.
        - Besides the expected ones, binaries I have installed that may be useful to you include tree, docker, ripgrep, zip, unzip${
          (if !isHeadless then ", wl-copy, wl-paste, wp-cli." else ".")
        }
        - Don't use em dashes in write-ups intended for clients.
      '';
      mcpServers = lib.mkIf (!isHeadless) {
        astro = {
          url = "https://mcp.docs.astro.build/mcp";
          type = "http";
        };
        chrome-devtools = {
          command = "npx";
          args = [
            "-y"
            "chrome-devtools-mcp@latest"
            "--executablePath"
            "${pkgs.chromium}/bin/chromium"
          ];
          type = "stdio";
        };
        clickup = {
          url = "https://mcp.clickup.com/mcp";
          type = "http";
        };
        inspry = {
          url = "https://inspry-mcp-hub-production.up.railway.app/mcp";
          type = "http";
        };
        jetbrains = {
          url = "http://localhost:64342/sse";
          type = "sse";
        };
      };
      skills = lib.mkIf (!isHeadless) {
        wordpress-source-code = ../../claude/skills/wordpress-source-code;
        woocommerce-source-code = ../../claude/skills/woocommerce-source-code;
        wp-discovery = ../../claude/skills/wp-discovery;
      };
    };
  };
}
