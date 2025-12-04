# DroidFakeCam

This project contains a minimal Android app and accompanying Magisk module that demonstrate swapping the camera feed for the `vcam` virtual camera sink without using LSPosed. It is intended for educational research on camera spoofing mitigations on rooted devices.

## Components
- **Android app (Kotlin)** — provides a simple UI to query and toggle the Magisk module via the `/data/adb/modules/droidfakecam/bin/vcamctl` helper script.
- **Magisk module** — installs a `vcamctl` script, persists state, and exposes hooks for binding the vendor camera provider to the `vcam` device.

## Building the APK
1. Open the project in Android Studio Flamingo or newer with Android Gradle Plugin 8.7.1.
2. Let Gradle download dependencies, then run **Build > Make Project**.
3. The assembled APK will be at `app/build/outputs/apk/debug/app-debug.apk`.

## Installing the Magisk module
1. From a rooted shell, create a zip with the contents of `magisk-module/` and install it through the Magisk app.
2. Reboot to allow `service.sh` to create `/data/adb/modules/droidfakecam/bin/vcamctl` and set the persisted state property.
3. Use the Android app’s **Check Status** and **Enable vcam routing** buttons to control the module.

> ⚠️ The `route` action inside `vcamctl` is a placeholder. Each device requires a tailored bind-mount or camera-service restart sequence to point the HAL toward `vcam` (commonly `/dev/video99`). Add those commands under the `route_hal` function in `magisk-module/service.sh`.
