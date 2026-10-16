{
  isLaptop,
  lib,
  ...
}: {
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      fps_metrics = ["avg" "0.01" "0.001"];
      frame_timing = 1;
      gpu_stats = true;
      gpu_temp = true;
      gpu_power = true;
      vram = true;
      cpu_stats = true;
      cpu_temp = true;
      ram = true;
      gamemode = true;
      wine = true;
      battery = isLaptop;
      fps_limit = [0 60 120 180];
      show_fps_limit = true;
      resolution = true;
      toggle_fps_limit = "Shift_L+F1";
      position = "middle-right";
      round_corners = 4;
      no_small_font = true;

      # Override Stylix
      alpha = lib.mkForce 0.9;
      background_alpha = lib.mkForce 0.6;
    };
  };
}
