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
        "y" = "yazi";
      };
      initExtra = ''
        # Ctrl+arrows for word navigation
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        # Load bashcompinit
        autoload bashcompinit
        bashcompinit

        # wp-cli completion
        source ${pkgs.wp-cli}/share/bash-completion/completions/wp
      '';
    };
  };
}

