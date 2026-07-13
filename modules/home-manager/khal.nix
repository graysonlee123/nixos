{
  programs.khal = {
    enable = true;
    settings = {
      default = {
        default_event_duration = "2h";
        highlight_event_days = true;
        print_new = "event";
      };
      highlight_days = {
        method = "bg";
      };
      keybindings = {
        new = "n, a";
      };
      view = {
        blank_line_before_day = true;
        frame = "color";
      };
    };
  };
}
