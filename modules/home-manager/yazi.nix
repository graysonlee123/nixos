{
  config = {
    programs.yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
          linemode = "size";
        };
        opener = {
          edit = [
            { run = "vim \"$@\""; desc = "vim"; for = "unix"; block = true; }
            { run = "code \"$@\""; desc = "VS Code"; for = "unix"; block = false; orphan = true; }
          ];
          play = [
            { run = "vlc \"$@\""; orphan = true; for = "unix"; }
          ];
          open = [
            { run = "xdg-open \"$@\""; desc = "XDG Open"; }
          ];
          extract = [
            { run = "ya pub extract --list \"$@\""; desc = "Extract here"; }
          ];
          download = [
            { run = "ya emit download --open \"$@\""; desc = "Download and open"; }
            { run = "ya emit download \"$@\""; desc = "Download"; }
          ];
        };
        open.rules = [
          # Text/code
          { mime = "text/*"; use = "edit"; }
          { mime = "application/json"; use = "edit"; }
          { mime = "application/javascript"; use = "edit"; }
          { mime = "application/x-yaml"; use = "edit"; }
          { mime = "application/xml"; use = "edit"; }
          { mime = "application/toml"; use = "edit"; }
          { mime = "inode/empty"; use = "edit"; }

          # Images
          { mime = "image/svg+xml"; use = [ "open" "edit" ]; }
          { mime = "image/*"; use = "open"; }

          # Media
          { mime = "video/*"; use = "play"; }
          { mime = "audio/*"; use = "play"; }

          # Documents
          { mime = "application/pdf"; use = "open"; }

          # Archives
          { mime = "application/zip"; use = "extract"; }
          { mime = "application/x-tar"; use = "extract"; }
          { mime = "application/gzip"; use = "extract"; }
          { mime = "application/x-gzip"; use = "extract"; }

          # Fallback
          { url = "*"; use = "open"; }
        ];
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

