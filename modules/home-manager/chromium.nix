{ pkgs, ... }:

let
  bookmark-utils = import ../utils/bookmarks.nix;
  bookmarks = import ./bookmarks.nix;
in {
  config = {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override {
        enableWideVine = true;
      };
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "dnebklifojaaecmheejjopgjdljebpeo"; } # everhour
      ];
    };

    # Declarative read-only bookmarks for both profiles
    xdg.configFile."chromium/Default/Bookmarks" = {
      text = bookmark-utils.mkChromiumBookmarks bookmarks.personal;
      force = true; # Make read-only to enforce declarative management
    };

    xdg.configFile."chromium/Profile 1/Bookmarks" = {
      text = bookmark-utils.mkChromiumBookmarks bookmarks.inspry;
      force = true; # Make read-only to enforce declarative management
    };
  };
}
