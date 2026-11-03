{config, ...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings.shell-integration-features = "ssh-env";
    # background-opacity comes from stylix.opacity.terminal

    # Stay resident so new windows open instantly (no cold GTK/GPU start).
    settings.quit-after-last-window-closed = false;
  };

  # HM installs the unit but never enables it; start it with the session.
  # Launch windows with `ghostty +new-window` to reuse this instance.
  xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source = "${config.programs.ghostty.package}/share/systemd/user/app-com.mitchellh.ghostty.service";

  # Default terminal for Terminal=true apps (GLib/Thunar, launchers)
  xdg.terminal-exec = {
    enable = true;
    settings.default = ["com.mitchellh.ghostty.desktop"];
  };
}
