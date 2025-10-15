#!/system/bin/sh
# Magisk module installation script for DroidFakeCam virtual camera
# This script provides the vcam.apk for manual installation and does not rely on LSPosed.
# Variables provided by Magisk
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

# Called when the module is installed or upgraded
on_install() {
    ui_print "- Installing DroidFakeCam virtual camera module"
}



# Set permissions on installed files
set_permissions() {
  set_perm "$MODPATH/vcam.apk"  0  0  0644
}
