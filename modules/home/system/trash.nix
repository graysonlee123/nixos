{pkgs, ...}: {
  # Purge trash items older than 30 days
  systemd.user.services.trash-empty = {
    Unit.Description = "Purge trash items older than 30 days";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.trash-cli}/bin/trash-empty -f 30";
    };
  };
  systemd.user.timers.trash-empty = {
    Unit.Description = "Daily trash purge";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
