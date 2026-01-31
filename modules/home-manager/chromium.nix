{ ... }:

let
  bookmarks = import ../utils/bookmarks.nix;
in {
  config = {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "dnebklifojaaecmheejjopgjdljebpeo"; } # everhour
      ];
    };

    # Declarative read-only bookmarks for both profiles
    xdg.configFile."chromium/Default/Bookmarks" = {
      text = bookmarks.mkChromiumBookmarks bookmarks.work;
      force = true; # Make read-only to enforce declarative management
    };

    xdg.configFile."chromium/Profile 1/Bookmarks" = {
      text = bookmarks.mkChromiumBookmarks bookmarks.personal;
      force = true; # Make read-only to enforce declarative management
    };
  };
}
