# fwupd: firmware update daemon. Pulls BIOS/UEFI, EC, SSD, dock, touchpad,
# USB-C controller firmware from LVFS (https://fwupd.org). UEFI capsule
# updates are staged in the ESP and applied by firmware on next reboot.
#
# Basic usage:
#   fwupdmgr get-devices   # list devices + current firmware versions
#   fwupdmgr refresh       # fetch latest metadata from LVFS
#   fwupdmgr get-updates   # list available updates
#   fwupdmgr update        # install/stage updates (reboot to apply BIOS)
#   fwupdmgr get-history   # past updates + results
#
# Not every model is on LVFS; if get-updates shows nothing for a device,
# check the vendor's support site. Keep AC plugged in during BIOS updates.
{
  services.fwupd.enable = true;
}
