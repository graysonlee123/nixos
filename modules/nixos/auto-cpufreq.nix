{
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        # To get available governors run:
        # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
        governor = "performance";

        # To get available EPP preferences run:
        # cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
        energy_performance_preference = "performance";
      };
      battery = {
        # To get available governors run:
        # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
        governor = "powersave";

        # To get available EPP preferences run:
        # cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
        energy_performance_preference = "balance_power";
      };
    };
  };
}
