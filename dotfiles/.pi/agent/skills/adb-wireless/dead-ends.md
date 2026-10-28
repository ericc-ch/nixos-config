# Dead ends

Each entry is confirmed on this device. Do not spend time retrying them.

- `settings put global adb_wifi_enabled 1` from Termux throws
  `SecurityException: requires INTERACT_ACROSS_USERS`, which an app cannot be
  granted. `/system/bin/settings` hits the same wall. It only works from inside
  an adb shell, which is circular for the first enable.
- `adb mdns services` prints nothing - this adb build has no mDNS support. That
  is why `adb-port.py` speaks mDNS itself.
- `/proc/net/tcp` is empty, so the port cannot be read from the filesystem.
- Termux cannot read `/data/app/...`, so `adb pull` is the only way to get an
  APK that was installed from Play.
- Flutter apps decompile to nothing useful in `jadx`: the Dart AOT logic lives
  in `libapp.so`, not in the Java/Kotlin layer. Use Blutter, or capture traffic.
