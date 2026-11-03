{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings.shell-integration-features = "ssh-env";
    # background-opacity comes from stylix.opacity.terminal
  };

  # Default terminal for Terminal=true apps (GLib/Thunar, launchers)
  xdg.terminal-exec = {
    enable = true;
    settings.default = ["com.mitchellh.ghostty.desktop"];
  };
}
