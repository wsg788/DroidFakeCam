#!/system/bin/sh
MODDIR=${0%/*}
BIN_DIR="$MODDIR/bin"
STATE_FILE="$MODDIR/state"

echo "[droidfakecam] service.sh bootstrapping" > "$MODDIR/service.log"

mkdir -p "$BIN_DIR"

if [ ! -f "$STATE_FILE" ]; then
  echo "vcam_sink=disabled" > "$STATE_FILE"
fi

cat > "$BIN_DIR/vcamctl" <<'EOS'
#!/system/bin/sh
MODDIR=/data/adb/modules/droidfakecam
STATE_FILE="$MODDIR/state"
VCAM_DEV="/dev/video99"

usage() {
  echo "Usage: vcamctl [status|enable|disable|toggle|route]"
}

current_state() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    echo "vcam_sink=unknown"
  fi
}

ensure_state_file() {
  if [ ! -f "$STATE_FILE" ]; then
    echo "vcam_sink=disabled" > "$STATE_FILE"
  fi
}

enable_sink() {
  echo "vcam_sink=enabled" > "$STATE_FILE"
  setprop persist.droidfakecam.vcam_sink enabled
  echo "enabled"
}

disable_sink() {
  echo "vcam_sink=disabled" > "$STATE_FILE"
  setprop persist.droidfakecam.vcam_sink disabled
  echo "disabled"
}

route_hal() {
  # This is a placeholder for OEM-specific camera routing. The intention is
  # to re-point the vendor camera HAL provider toward vcam so that apps see
  # the spoofed feed instead of the physical sensor.
  #
  # Example actions that can be added here:
  #   - bind-mount a replacement camera provider library
  #   - symlink vendor camera sockets to the vcam sink
  #   - stop and restart cameraserver after applying the override
  #
  echo "vcam route placeholder: implement device-specific routing to $VCAM_DEV"
}

ensure_state_file
case "$1" in
  status)
    current_state ;;
  enable)
    enable_sink ;;
  disable)
    disable_sink ;;
  toggle)
    if grep -q "enabled" "$STATE_FILE"; then
      disable_sink
    else
      enable_sink
    fi ;;
  route)
    route_hal ;;
  *)
    usage ;;
esac
EOS

chmod 755 "$BIN_DIR/vcamctl"

# Apply persisted state on boot
if grep -q "enabled" "$STATE_FILE"; then
  setprop persist.droidfakecam.vcam_sink enabled
else
  setprop persist.droidfakecam.vcam_sink disabled
fi
