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
           
    # Copy vcam.apk to /data/local/tmp
    cp "$MODPATH/vcam.apk" /data/local/tmp/vcam.apk
    # Install the APK using pm
    pm install -r /data/local/tmp/vcam.apk >/dev/null 2>&1
}



# Set permissions on installed files
set_permissions() {
  set_perm "$MODPATH/vcam.apk"  0  0  0644
}
