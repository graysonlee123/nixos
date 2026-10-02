{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings.shell-integration-features = "ssh-env";
    settings = {
      background-opacity = 0.97;
    };
  };

  # Default terminal for Terminal=true apps (GLib/Thunar, launchers)
  xdg.terminal-exec = {
    enable = true;
    settings.default = ["com.mitchellh.ghostty.desktop"];
  };
}
