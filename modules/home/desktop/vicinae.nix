# vicinae.mkExtension def: https://github.com/nix-community/home-manager/blob/693e8ce0fb240a73c116a03cfd7b19269c87af88/modules/programs/vicinae/lib.nix
{
  config,
  pkgs,
  ...
}: {
  programs.vicinae = {
    enable = true;
    settings = {
      pop_to_root_on_close = true;
      theme = {
        name = "stylix";
      };
      # Clipboard history: Enter copies instead of pasting into focused app.
      providers.clipboard.entrypoints.history.preferences.defaultAction = "copy";
    };
    extensions = [
      (config.lib.vicinae.mkExtension {
        name = "nix";
        src =
          pkgs.fetchFromGitHub {
            owner = "vicinaehq";
            repo = "extensions";
            rev = "62bcab8ca590d37c8443cb2aee2e83ef656e389f";
            sha256 = "sha256-j3g10f7sHHPbcN6tQIJmKatyOANJzHc5o9zAQlNrnOw=";
          }
          + /extensions/nix;
      })
      (config.lib.vicinae.mkExtension {
        name = "gtoolbox";
        src = pkgs.fetchFromGitHub {
          owner = "graysonlee123";
          repo = "gtoolbox";
          rev = "99e23f9a7c84da41486d1b1fc70b8ef8dba6a4c5";
          sha256 = "sha256-/dB7cr3MUEBa1EWaWTln5v1Nq7dF6x5nNDZM6TLagkc=";
        };
      })
    ];
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };
}
