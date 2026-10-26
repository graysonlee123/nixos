{
  services.udev.extraRules = ''
    # Keychron M3 (wired d033) + Keychron Link receiver (d030): WebHID access for launcher.keychron.com
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d033", MODE="0660", GROUP="users", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0660", GROUP="users", TAG+="uaccess"
  '';
}
