# Declarative Chromium bookmarks for all profiles
#
# This file defines bookmarks for both personal and work Chromium profiles.
# These bookmarks are deployed as read-only to ensure declarative management.

rec {
  # Helper functions to convert bookmarks to Chromium's JSON format
  mkBookmark = name: url: {
    inherit name url;
    type = "url";
    date_added = "13366140461000000";
  };

  mkFolder = name: children: {
    inherit name children;
    type = "folder";
    date_added = "13366140461000000";
    date_modified = "0";
  };

  # Convert bookmark list to Chromium format
  convertBookmark = item:
    if item ? children then
      mkFolder item.name (map convertBookmark item.children)
    else
      mkBookmark item.name item.url;

  # Generate Chromium bookmarks JSON for a bookmark set
  mkChromiumBookmarks = bookmarkSet: builtins.toJSON {
    checksum = "";
    roots = {
      bookmark_bar = mkFolder "Bookmarks bar" (map convertBookmark bookmarkSet.bookmarks_bar);
      other = mkFolder "Other bookmarks" (map convertBookmark bookmarkSet.other);
      synced = mkFolder "Mobile bookmarks" [];
    };
    version = 1;
  };
}

