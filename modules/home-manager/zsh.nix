{ pkgs, ... }:

{
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        "cl" = "claude";
        "lzd" = "lazydocker";
        "lzg" = "lazygit";
        "pn" = "pnpm";
        "rb" = "radioboat --volume 50 --track-file ~/.config/radioboat/tracks.txt";
        "dcd" = "docker compose down";
        "dcu" = "docker compose up";
        "dcud" = "docker compose up -d";
        "dclf" = "docker compose logs --follow";
      };
      initContent = ''
        # Ctrl+arrows for word navigation
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        # Load bashcompinit
        autoload bashcompinit
        bashcompinit

        # wp-cli completion
        source ${pkgs.wp-cli}/share/bash-completion/completions/wp

        # yazi shell wrapper providing cwd changes on exit
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d \'\' cwd < "$tmp"
          [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }

        bindkey -e
      '';
    };
  };
}

