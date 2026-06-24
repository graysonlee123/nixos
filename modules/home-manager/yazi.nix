{
  config,
  pkgs,
  lib,
  isHeadless,
  ...
}:

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
            {
              run = "vim \"$@\"";
              desc = "vim";
              for = "unix";
              block = true;
            }
          ]
          ++ lib.optional (!isHeadless) {
            run = "code \"$@\"";
            desc = "VS Code";
            for = "unix";
            block = false;
            orphan = true;
          };
          play = lib.optional (!isHeadless) {
            run = "vlc \"$@\"";
            orphan = true;
            for = "unix";
          };
          open = lib.optional (!isHeadless) {
            run = "xdg-open \"$@\"";
            desc = "XDG Open";
          };
          extract = [
            {
              run = "ya pub extract --list \"$@\"";
              desc = "Extract here";
            }
          ];
          download = [
            {
              run = "ya emit download --open \"$@\"";
              desc = "Download and open";
            }
            {
              run = "ya emit download \"$@\"";
              desc = "Download";
            }
          ];
        };
        open.rules = [
          # Text/code
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "application/json";
            use = "edit";
          }
          {
            mime = "application/javascript";
            use = "edit";
          }
          {
            mime = "application/x-yaml";
            use = "edit";
          }
          {
            mime = "application/xml";
            use = "edit";
          }
          {
            mime = "application/toml";
            use = "edit";
          }
          {
            mime = "inode/empty";
            use = "edit";
          }

          # Images
          {
            mime = "image/svg+xml";
            use = lib.optional (!isHeadless) "open" ++ [ "edit" ];
          }

          # Archives
          {
            mime = "application/zip";
            use = "extract";
          }
          {
            mime = "application/x-tar";
            use = "extract";
          }
          {
            mime = "application/gzip";
            use = "extract";
          }
          {
            mime = "application/x-gzip";
            use = "extract";
          }
        ]
        ++ lib.optionals (!isHeadless) [
          # Media
          {
            mime = "image/*";
            use = "open";
          }
          {
            mime = "video/*";
            use = "play";
          }
          {
            mime = "audio/*";
            use = "play";
          }

          # Documents
          {
            mime = "application/pdf";
            use = "open";
          }

          # Fallback
          {
            url = "*";
            use = "open";
          }
        ];
        input = {
          cursor_blink = true;
        };
      };
      plugins = {
        restore = pkgs.yaziPlugins.restore;
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = [
              "g"
              "t"
            ];
            run = "cd /tmp";
            desc = "Go /tmp";
          }
          {
            on = [
              "g"
              "s"
            ];
            run = "cd ${config.home.homeDirectory}/syncthing";
            desc = "Go ~/syncthing";
          }
          {
            on = [ "u" ];
            run = "plugin restore -- --interactive";
            desc = "Restore last deleted files/folders";
          }
        ]
        ++ lib.optionals (!isHeadless) [
          {
            on = [
              "g"
              "d"
            ];
            run = "cd ~/downloads";
            desc = "Go ~/downloads";
          }
          {
            on = [
              "g"
              "i"
            ];
            run = "cd ~/repos/inspry";
            desc = "Go ~/repos/inspry";
          }
          {
            on = [
              "g"
              "m"
            ];
            run = "cd ~/repos/me/";
            desc = "Go ~/repos/me";
          }
          {
            on = [ "Y" ];
            run = "shell 'wl-copy < \"$1\"'";
            desc = "Copy to clipboard";
          }
        ];
      };
    };
  };
}
