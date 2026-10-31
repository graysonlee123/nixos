# vicinae.mkExtension def: https://github.com/nix-community/home-manager/blob/693e8ce0fb240a73c116a03cfd7b19269c87af88/modules/programs/vicinae/lib.nix
{
  config,
  pkgs,
  ...
}: let
  # Vicinae reads these JSON stores once at startup. Home Manager owns them as
  # read-only symlinks: Nix is the source of truth, GUI edits and usage counters
  # fail (logged warning only). Ids are fixed so `fallbacks` can reference them.
  shortcuts = [
    {
      id = "google";
      name = "Google";
      url = "https://google.com/search?q={argument}";
      app = "chromium-browser.desktop";
      icon = "icon://favicon/google.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
    }
    {
      id = "duckduckgo";
      name = "DuckDuckGo";
      url = "https://duckduckgo.com/?q={argument}";
      app = "chromium-browser.desktop";
      icon = "icon://favicon/duckduckgo.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
    }
    {
      id = "inspry-repos";
      name = "Inspry Repos";
      url = "https://github.com/orgs/inspry/repositories?q={argument}";
      app = "chromium-browser.desktop";
      icon = "icon://favicon/github.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
    }
    {
      id = "inspry-pressable";
      name = "Pressable";
      url = "https://my.pressable.com/sites?search_term={argument}";
      app = "chromium-browser.desktop";
      icon = "icon://favicon/pressable.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
    }
    {
      id = "minecraft-wiki";
      name = "Minecraft wiki";
      url = "https://minecraft.wiki/?search={argument}";
      app = "chromium-browser.desktop";
      icon = "icon://favicon/minecraft.wiki?fallback=icon://omnicast/image?fill%3Dprimary-text";
    }
  ];
  # Text supports placeholders: {cursor}, {clipboard}, {uuid}, {date format="<Qt format>"},
  # {shell code="..."}. Word mode expands after a word boundary (e.g. space).
  #
  # Keywords are ";<group><name>".
  mkSnippet = id: name: keyword: text: {
    inherit id name;
    data.text = text;
    expansion = {
      inherit keyword;
      apps = [];
      word = true;
    };
  };
  snippets = [
    # a = arrows
    (mkSnippet "right-arrow" "Right Arrow" ";ar" "→")
    (mkSnippet "left-arrow" "Left Arrow" ";al" "←")
    (mkSnippet "up-arrow" "Up Arrow" ";au" "↑")
    (mkSnippet "down-arrow" "Down Arrow" ";ad" "↓")

    # m = math
    (mkSnippet "division-slash" "Division Slash" ";mds" "∕")
    (mkSnippet "division-sign" "Division Sign" ";mdsi" "÷")
    (mkSnippet "multiply-sign" "Multiply Sign" ";mms" "×")
    (mkSnippet "plus-minus" "Plus/Minus" ";mpm" "∓")

    # d = dashes
    (mkSnippet "en-dash" "En dash" ";den" "–")
    (mkSnippet "em-dash" "Em dash" ";dem" "—")

    # d = dates/time
    (mkSnippet "date" "Date" ";dd" ''{date format="yyyy-MM-dd"}'')
    (mkSnippet "datetime" "Date and Time" ";ddt" ''{date format="yyyy-MM-dd HH:mm"}'')
    (mkSnippet "timestamp" "Unix Timestamp" ";dts" ''{shell code="date +%s"}'')

    # g = generated
    (mkSnippet "uuid" "UUID" ";gid" "{uuid}")

    # i = Inspry
    (mkSnippet "inspry-phone" "Inspry Phone" ";iph" "(470) 970-3903")
    (mkSnippet "inspry-email" "Inspry Email" ";iem" "hello@inspry.com")
  ];
  toStore = name: entries:
    pkgs.writeText "vicinae-${name}.json" (builtins.toJSON (map (e: e // {createdAt = 0;}) entries));
  shortcutsFile = toStore "shortcuts" shortcuts;
  snippetsFile = toStore "snippets" snippets;
in {
  systemd.user.services.vicinae = {
    # Vicinae has no reload IPC; sd-switch restarts once when either store changes.
    Unit.X-Restart-Triggers = ["${shortcutsFile}" "${snippetsFile}"];
    # Setcap'd wrapper from modules/nixos/desktop/vicinae.nix (snippet expansion).
    Service.Environment = "VICINAE_INPUT_SERVER_BIN=/run/wrappers/bin/vicinae-input-server";
  };

  programs.vicinae = {
    enable = true;
    settings = {
      pop_to_root_on_close = true;
      theme = {
        name = "stylix";
      };
      # Clipboard history: Enter copies instead of pasting into focused app.
      providers.clipboard.entrypoints.history.preferences.defaultAction = "copy";
      # Snippet undo (backspace right after expansion) fires on key press; VS Code
      # drops injected backspaces while the real one is held, leaving e.g. "→;ar".
      providers.snippets.preferences.undo = false;
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

  xdg.dataFile."vicinae/shortcuts/shortcuts.json".source = shortcutsFile;
  xdg.dataFile."vicinae/snippets/snippets.json".source = snippetsFile;
}
