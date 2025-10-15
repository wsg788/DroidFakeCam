#!/system/bin/sh
# Magisk module installation script for DroidFakeCam virtual camera
# This script copies the vcam.apk (LSPosed module) into the LSPosed modules directory.

# Variables provided by Magisk
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

# Called when the module is installed or upgraded
on_install() {
  ui_print "- Installing DroidFakeCam virtual camera LSPosed module"

  # Copy the embedded APK to LSPosed modules directory
  # Attempt typical locations; adjust paths based on device environment
  cp "$MODPATH/vcam.apk" "/data/adb/lspd/modules/droidfakecam-vcam.apk" 2>/dev/null
  cp "$MODPATH/vcam.apk" "/data/adb/modules_update/droidfakecam-vcam/droidfakecam-vcam.apk" 2>/dev/null
  cp "$MODPATH/vcam.apk" "/data/adb/modules/droidfakecam-vcam/droidfakecam-vcam.apk" 2>/dev/null
}

# Set permissions on installed files
set_permissions() {
  set_perm "$MODPATH/vcam.apk"  0  0  0644
}
