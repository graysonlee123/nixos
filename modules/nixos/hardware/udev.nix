# Retrieve device IDs using `, lsusb`.
{
  services.udev.extraRules = ''
    # Keychron M3 (wired d033) + Keychron Link receiver (d030): WebHID access for launcher.keychron.com
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d033", MODE="0660", GROUP="users", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0660", GROUP="users", TAG+="uaccess"

    # MelGeek Horus (wired 0201) + MelGeek Pyramid receiver (0302): WebHID access for hive.melgeek.com
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3854", ATTRS{idProduct}=="0201", MODE="0660", GROUP="users", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3854", ATTRS{idProduct}=="0302", MODE="0660", GROUP="users", TAG+="uaccess"
  '';
}
