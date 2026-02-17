{
  config = {
    programs.yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
          linemode = "size";
        };
        input = {
          cursor_blink = true;
        };
      };
      keymap = {
        mgr.prepend_keymap = [
          { on = [ "g" "d" ]; run = "cd ~/downloads"; desc = "Go ~/downloads"; }
          { on = [ "g" "i" ]; run = "cd ~/repos/inspry"; desc = "Go ~/repos/inspry"; }
          { on = [ "g" "m" ]; run = "cd ~/repos/me/"; desc = "Go ~/repos/me"; }
        ];
      };
    };
  };
}

