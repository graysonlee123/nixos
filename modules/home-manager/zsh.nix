{ config, ... }:

{
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        extended = true;
      };
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
        "lftpi" = "lftp -e 'set ssl:verify-certificate no'";
      };
      initContent = ''
        bindkey "^[[3~" delete-char
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      ''
      + (
        if config.programs.khal.enable then
          ''
            eval "$(_KHAL_COMPLETE=zsh_source khal)"
          ''
        else
          ""
      );
    };
  };
}
