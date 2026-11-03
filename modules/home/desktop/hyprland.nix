{
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = let
      workspaces = [1 2 3 4 5 6 7 8 9];
      directions = ["up" "right" "down" "left"];
      anim = leaf: attrs: {
        _args = [
          ({
              inherit leaf;
              enabled = true;
            }
            // attrs)
        ];
      };
      bez = name: p1: p2: {
        _args = [
          name
          {
            type = "bezier";
            points = [p1 p2];
          }
        ];
      };
      spr = name: stiffness: dampening: {
        _args = [
          name
          {
            type = "spring";
            mass = 1;
            inherit stiffness dampening;
          }
        ];
      };
    in {
      mod = {_var = "SUPER";};

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          resize_on_border = true;
        };

        input = {
          repeat_rate = 75;
          repeat_delay = 200;
          sensitivity = -0.2;
          accel_profile = "flat";
        };

        decoration = {
          rounding = 10;
          rounding_power = 4.0;
          shadow = {
            offset = [0 2];
          };
          dim_inactive = true;
          dim_strength = 0.125;
        };

        master = {
          orientation = "right";
          mfact = 0.66;
        };

        scrolling = {
          column_width = 0.66;
          direction = "down";
        };

        binds = {
          drag_threshold = 10;
          workspace_back_and_forth = true;
        };

        cursor = {
          hide_on_key_press = true;
        };

        misc = {
          disable_splash_rendering = true;
          focus_on_activate = true;
        };
      };

      curve = [
        (bez "outQuint" [0.23 1] [0.32 1]) # fast start, long soft landing
        (bez "outBack" [0.34 1.56] [0.64 1]) # overshoot, then settle
        (bez "inQuart" [0.5 0] [0.75 0]) # slow start, fast exit (good for close)
        (bez "linear" [0 0] [1 1])
        (spr "bouncy" 120 12) # visible bounce
        (spr "snappy" 200 22) # quick, tiny bounce
      ];

      animation = [
        (anim "windowsIn" {
          spring = "bouncy";
          speed = 4;
          style = "popin 85%";
        })
        (anim "windowsOut" {
          bezier = "inQuart";
          speed = 2;
          style = "popin 90%";
        })
        (anim "windowsMove" {
          spring = "snappy";
          speed = 4;
        })
        (anim "fade" {
          bezier = "outQuint";
          speed = 2;
        })
        (anim "fadeDim" {
          bezier = "outQuint";
          speed = 5;
        })
        (anim "workspaces" {
          spring = "snappy";
          speed = 4;
          style = "slide";
        })
        (anim "specialWorkspace" {
          bezier = "outBack";
          speed = 4;
          style = "slidefadevert -50%";
        })
        (anim "layersIn" {
          bezier = "outBack";
          speed = 3;
          style = "fade";
        })
        (anim "layersOut" {
          bezier = "inQuart";
          speed = 2;
          style = "fade";
        })
        (anim "border" {
          bezier = "outQuint";
          speed = 5;
        })
      ];

      monitor = [
        {
          output = "HDMI-A-1";
          position = "0x0";
          mode = "preferred";
          transform = 1;
        }

        {
          output = "DP-1";
          position = "1080x160";
          mode = "preferred";
        }
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = "DP-1";
          default = true;
          persistent = true;
        }
        {
          workspace = "2";
          monitor = "DP-1";
          layout = "master";
        }
        {
          workspace = "3";
          monitor = "DP-1";
          layout = "master";
        }
        {
          workspace = "4";
          monitor = "HDMI-A-1";
          default = true;
          persistent = true;
          layout = "scrolling";
        }
        {
          workspace = "5";
          monitor = "HDMI-A-1";
          layout = "scrolling";
        }
        {
          workspace = "8";
          on_created_empty = "tidal-hifi";
        }
      ];

      window_rule = [
        {
          match = {
            class = "^com\\.mitchellh\\.ghostty\\.float$";
          };
          float = true;
        }
        {
          match = {
            title = "^Picture in picture$";
          };
          float = true;
          pin = true;
          keep_aspect_ratio = true;
          size = [480 270];
          move = ["monitor_w-window_w-20" "monitor_h-window_h-20"];
        }
        {
          match = {
            class = "^1[Pp]assword$";
          };
          no_screen_share = true;
        }
      ];

      layer_rule = [
        {
          match = {
            namespace = "notifications";
          };
          no_screen_share = true;
          animation = "slide right";
        }
        {
          match = {
            namespace = "hyprpaper";
          };
          no_anim = true;
        }
        {
          match = {
            namespace = "waybar";
          };
          animation = "slide top";
        }
      ];

      bind =
        [
          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + Q\"")
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + RETURN\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + RETURN\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"ghostty --class=com.mitchellh.ghostty.float\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + BACKSLASH\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"thunar\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + D\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"vicinae toggle\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + B\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"chromium\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + C\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"code\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + P\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"phpstorm\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + f\"")
              (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + SPACE\"")
              (lib.generators.mkLuaInline "hl.dsp.window.float()")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + g\"")
              (lib.generators.mkLuaInline "hl.dsp.group.toggle()")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + P\"")
              (lib.generators.mkLuaInline "hl.dsp.window.pin()")
            ];
          }

          {
            _args = [
              "Print"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd('${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -b \"#00000099\" -c \"#00ff41\")\" - | ${pkgs.satty}/bin/satty --filename -')")
            ];
          }

          {
            _args = [
              "XF86AudioMute"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl play-pause\")")
            ];
          }

          {
            _args = [
              "XF86AudioMute"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl play-pause\")")
            ];
          }

          {
            _args = [
              "XF86AudioLowerVolume"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-\")")
            ];
          }

          {
            _args = [
              "XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+\")")
            ];
          }

          {
            _args = [
              "ALT + mouse:272"
              (lib.generators.mkLuaInline "hl.dsp.window.drag()")
              (lib.generators.mkLuaInline "{ mouse = true }")
            ];
          }

          {
            _args = [
              "ALT + SHIFT + mouse:272"
              (lib.generators.mkLuaInline "hl.dsp.window.resize()")
              (lib.generators.mkLuaInline "{ mouse = true }")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + n\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"makoctl dismiss --all\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + ESCAPE\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pkgs.systemd}/bin/loginctl lock-session\")")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + mouse_down\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + mouse_up\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + mouse_down\"")
              (lib.generators.mkLuaInline "hl.dsp.window.cycle_next()")
            ];
          }

          {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + mouse_up\"")
              (lib.generators.mkLuaInline "hl.dsp.window.cycle_next({ next = false })")
            ];
          }
        ]
        ++ (lib.map (d: {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + ${lib.strings.toUpper d}\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"${d}\" })")
            ];
          })
          directions)
        ++ (lib.map (d: {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + ${lib.strings.toUpper d}\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"${d}\" })")
            ];
          })
          directions)
        ++ (lib.map (
            w: {
              _args = [
                (lib.generators.mkLuaInline "mod .. \" + ${toString w}\"")
                (lib.generators.mkLuaInline "hl.dsp.focus({workspace = ${toString w}})")
              ];
            }
          )
          workspaces)
        ++ (lib.map (w: {
            _args = [
              (lib.generators.mkLuaInline "mod .. \" + SHIFT + ${toString w}\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = ${toString w}})")
            ];
          })
          workspaces);
    };
  };
}
