{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gcloud = {
        disabled = true;
      };
      # Nerd Font nix logo (U+F313); 2 spaces because Ghostty draws icon 2 cells wide, covering 1
      nix_shell.symbol = builtins.fromJSON ''"\uf313  "'';
    };
  };
}
