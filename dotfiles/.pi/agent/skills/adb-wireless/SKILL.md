---
name: adb-wireless
description: Wireless adb from Termux - finds this phone's changing adb port over mDNS, pairs once, connects. Use for adb shell, logcat, or pulling APKs off this phone with no USB cable, root, or Shizuku.
---

# Wireless adb from Termux

Pairing happens once per machine. The port is random and changes every time
wireless debugging is toggled, so the scripts ask mDNS for it instead of reading
it off the Settings screen.

## Connect

```bash
adb devices                # a line ending in `device` means already connected
scripts/adb-connect.sh     # otherwise: connects and prints localhost:PORT
```

An empty list means wireless debugging is off. It turns itself off on reboot and
on Wi-Fi changes, and no CLI can turn it back on: tap the **Wireless debugging**
Quick Settings tile, then run the script again.

Plain `adb` works for the rest of the session:

```bash
adb shell pm list packages -3
adb logcat -s AndroidRuntime
adb pull /sdcard/Download/file.apk .
```

## Pair a new machine

Open **Wireless debugging > Pair device with pairing code**, leave the dialog
open, then run:

```bash
scripts/adb-pair.sh 123456
```

The pairing port exists only while that dialog is open. Pair again only after a
factory reset, or when another machine ran `adb kill-server`.

## Set up a fresh Termux

```bash
pkg install android-tools python
mkdir -p $HOME/.local/bin
ln -sf $HOME/nixos-config/dotfiles/.pi/agent/skills/adb-wireless/scripts/*.sh $HOME/.local/bin/
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
```

`android-tools` provides `adb`, `python` runs the mDNS query, and nothing else is
needed. Calling the scripts by path works without the last two lines.

## When a step fails

Read `dead-ends.md` before retrying. Every entry there is a wall already
confirmed on this device, so a session spent on it is wasted.
