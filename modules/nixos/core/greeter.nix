{
  programs.regreet = {
    enable = true;
    # Default cage mode (extend) spans all outputs as one window, so on
    # multi-monitor hosts the login form straddles the seam. Use one output.
    cageArgs = ["-s" "-d" "-m" "last"];
  };

  # Restarting greetd on switch kills the logged-in session.
  # Pick up greeter changes on next login/boot instead.
  systemd.services.greetd.restartIfChanged = false;
}
