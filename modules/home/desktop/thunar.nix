{
  # Preferences; applied via xfconf-query on switch (Thunar can still change at runtime)
  # Window size, pane position, column widths left unmanaged (runtime state)
  xfconf.settings.thunar = {
    # View
    last-view = "ThunarDetailsView";
    last-details-view-zoom-level = "THUNAR_ZOOM_LEVEL_38_PERCENT";
    last-icon-view-zoom-level = "THUNAR_ZOOM_LEVEL_100_PERCENT";
    last-show-hidden = true;
    last-sort-column = "THUNAR_COLUMN_NAME";
    last-sort-order = "GTK_SORT_ASCENDING";
    last-restore-tabs = true;
    last-details-view-fixed-columns = true; # manual widths; name column fills rest
    last-details-view-visible-columns = "THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_NAME,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_SIZE";
    last-details-view-column-order = "THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_SIZE_IN_BYTES,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_LOCATION,THUNAR_COLUMN_MIME_TYPE,THUNAR_COLUMN_DATE_CREATED,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_DATE_ACCESSED,THUNAR_COLUMN_RECENCY,THUNAR_COLUMN_DATE_DELETED";

    # Chrome
    last-location-bar = "ThunarLocationEntry";
    last-side-pane = "THUNAR_SIDEPANE_TYPE_SHORTCUTS";
    last-toolbar-items = "menu:0,back:1,forward:1,open-parent:1,open-home:1,new-tab:0,new-window:0,toggle-split-view:0,undo:0,redo:0,zoom-out:0,zoom-in:0,zoom-reset:0,view-as-icons:0,view-as-detailed-list:0,view-as-compact-list:0,view-switcher:0,location-bar:1,reload:0,search:1,uca-action-1790964923859740-1:0";
    shortcuts-icon-size = "THUNAR_ICON_SIZE_16";
    tree-icon-size = "THUNAR_ICON_SIZE_16";
    misc-symbolic-icons-in-sidepane = false;
    misc-use-csd = false; # sway draws decorations

    # Behavior
    misc-single-click = false;
    misc-date-style = "THUNAR_DATE_STYLE_LONG";
    misc-show-delete-action = true;
    misc-folder-item-count = "THUNAR_FOLDER_ITEM_COUNT_ONLY_LOCAL";
  };

  # Custom actions; force replaces the default uca.xml Thunar writes on first run
  xdg.configFile."Thunar/uca.xml" = {
    force = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
        <icon>utilities-terminal</icon>
        <name>Open Terminal Here</name>
        <submenu></submenu>
        <unique-id>1790964923859740-1</unique-id>
        <command>ghostty --working-directory=%f</command>
        <description>Open Ghostty in this folder</description>
        <range></range>
        <patterns>*</patterns>
        <startup-notify/>
        <directories/>
      </action>
      <action>
        <icon>vscode</icon>
        <name>Open in VS Code</name>
        <submenu></submenu>
        <unique-id>1790964923859740-2</unique-id>
        <command>code %f</command>
        <description>Open in Visual Studio Code</description>
        <range></range>
        <patterns>*</patterns>
        <directories/>
        <text-files/>
        <other-files/>
      </action>
      <action>
        <icon>edit-copy</icon>
        <name>Copy Path</name>
        <submenu></submenu>
        <unique-id>1790964923859740-3</unique-id>
        <command>wl-copy %F</command>
        <description>Copy full path to clipboard</description>
        <range></range>
        <patterns>*</patterns>
        <directories/>
        <audio-files/>
        <image-files/>
        <other-files/>
        <text-files/>
        <video-files/>
      </action>
      </actions>
    '';
  };
}
