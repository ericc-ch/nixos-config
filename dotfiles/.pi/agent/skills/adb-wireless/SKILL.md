---
name: adb-wireless
description: Drive this phone over adb from Termux with no USB, root, or Shizuku — mDNS port discovery, one-time pairing, and an auto-connect wrapper. Use when pulling APKs off the device, running logcat or shell commands, transferring files to another host.
compatibility: Termux on Android 11+, adb from `pkg install android-tools`
---

# adb over wireless debugging, from Termux

Wireless debugging authenticates once. What keeps breaking is the **port**: it
is random, and it changes every time the toggle is flipped. This phone
advertises the current port over mDNS, so discover it instead of reading the
Settings screen. That is the whole trick.

## Check the connection first

```bash
adb devices
```

A line ending in `device` means everything below is a no-op. An empty list means
wireless debugging is off — it turns itself off on reboot and on Wi-Fi changes.
One tap on the **Wireless debugging** Quick Settings tile restores it. There is
no CLI equivalent; see `Dead ends`.

## Use adb

The `adb` fish function (`dotfiles/.config/fish/functions/adb.fish`) connects
first when nothing is connected, then delegates:

```bash
adb shell pm list packages -3       # just works, after the QS tap
adb logcat -s AndroidRuntime
```

Commands that manage the connection themselves (`pair`, `connect`,
`kill-server`, `version`, `devices`, `mdns`) pass straight through, so they never
trigger a connect attempt first.

| Command | Does |
| --- | --- |
| `adbc` | force a (re)connect, prints `localhost:PORT`; drops stale `localhost:` entries |
| `adbp 123456` | pair — run it while the "Pair device with pairing code" dialog is open |
| `adbw ...` | connect-then-run, for shells without the fish function |
| `adb-port` | print the current port only (`--pair` for the pairing port) |

Cold start (adb server dead, nothing connected) takes ~700 ms; a warm call ~190 ms.
Pairing is once per device lifetime — the key in the phone's adb store survives
reboots. Pair again only after `adb kill-server` on a different machine's keys or
a factory reset.

## Pull an installed app

Split APKs mean several `pm path` lines. Pull all of them, they only assemble into
a working app together:

```bash
adb shell pm list packages -3 | grep -i <name>
adb shell pm path <pkg>
adb shell pm path <pkg> | sed 's/package://' | xargs -n1 adb pull .
aapt2 dump badging base.apk | head -5          # label, versionCode, targetSdk
```

Move the lot to another host with rsync over a private network (tailnet,
WireGuard, ssh alias — substitute your own):

```bash
rsync -rt --info=progress2 --no-perms --no-owner --no-group *.apk you@desktop:~/<dir>/
```

`--no-perms --no-owner --no-group` avoids Termux's uid mapping failing on the
receiver. Verify with `md5sum` on both ends.

## Dead ends

Don't spend a session on these; each one is confirmed on this device.

- `settings put global adb_wifi_enabled 1` from Termux throws
  `SecurityException: requires INTERACT_ACROSS_USERS`, which is not grantable to
  an app. `/system/bin/settings` reaches the same wall. Writing that setting from
  inside an adb session works (shell UID), which is circular for the first enable.
- `adb mdns services` → this adb build has no mDNS support, hence the Python.
- `cat /proc/net/tcp` is empty, so ports cannot be found from the filesystem side.
- Termux cannot read `/data/app/...`, so `adb pull` is the only way to a Play-installed APK.
- Flutter apps (`libflutter.so` + `libapp.so`) decompile to nothing useful in
  `jadx`; the Dart AOT logic lives in `libapp.so`. Reach for Blutter, or capture
  traffic instead.

## Optional: pin the port

`adb tcpip 5555` gives a plain non-TLS listener on a port that never changes, so
`adb connect localhost:5555` replaces discovery. Costs: plaintext adb exposed to
the whole Wi-Fi LAN (still key-authenticated), reset when wireless debugging
re-toggles, gone after reboot, and `adb usb` to revert also kills the session.
Get the QS tile ready before experimenting.

## Install on a fresh Termux

The scripts in `scripts/` need `python` (Termux package `python`) and nothing
else. Symlink them onto PATH and link the fish wrapper:

```bash
pkg install android-tools python
ln -sf ~/nixos-config/dotfiles/.pi/agent/skills/adb-wireless/scripts/{adb-port,adbc,adbp,adbw} ~/.local/bin/
ln -sf ~/nixos-config/dotfiles/.config/fish/functions/adb.fish ~/.config/fish/functions/
```

Then put `~/.local/bin` on PATH, or `adb.fish` cannot find `adbw`:

```fish
fish_add_path --global --path $HOME/.local/bin
```

That line belongs in `~/.config/fish/conf.d/local.fish`, which is gitignored as
machine-local state but is the file `home.file` already links. Without it `adb`
still works, it just never auto-connects — the wrapper guards with
`command -q adbw`, so a host without the scripts degrades to plain adb.
