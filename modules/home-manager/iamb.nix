# See https://iamb.chat/configure.html

{
  programs.iamb.enable = true;
  programs.iamb.settings = {
    profiles.user = {
      user_id = "@grayson:dendrite.lab.ggantek.net";
    };
    settings = {
      image_preview = {
        type = "kitty";
      };
      notifications.enabled = true;
      default_room = "@nora:dendrite.lab.ggantek.net";
    };
  };
}

