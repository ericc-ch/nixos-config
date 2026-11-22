---
name: localsend
description: "Sends files from this machine to a phone or other device over LocalSend (Tailscale or LAN), with no cloud and no pairing. Use when the user says send/send to phone/transfer/push a file to a device or names LocalSend."
---

# LocalSend

LocalSend is the default way to move files between this machine and the user's devices. It runs over the tailnet, so no LAN, no Syncthing, no cloud upload.

## Send

```bash
.agents/skills/localsend/scripts/send.sh <target> <file>...
```

`<target>` is a Tailscale hostname (`s25fe`) or `ip[:port]`. The script resolves the name, probes the device, uploads every file in one session, and prints one line per file.

The phone must have LocalSend open on the **Receive** screen. When the phone is asleep, backgrounded, or locked it stops answering and the script reports a timeout. Wake the app and run it again.

## Target

Find the device with `tailscale status`. The phone's LocalSend screen shows the same `ip:port` it is listening on, normally `:53317`.

```bash
curl -s http://s25fe:53317/api/localsend/v2/info
```

A 200 with `"alias":"Cool Lemon"` means the device is awake and accepting. An empty reply or a timeout means it is not.

## PIN

If the phone asks for a PIN, pass it:

```bash
.agents/skills/localsend/scripts/send.sh --pin 1234 s25fe file.pdf
```

The script exits with code 3 when a PIN is required and none was given.

## Gotchas

- **Foreground only.** Android backgrounds LocalSend aggressively. The first probe works, then the next request times out. Keep the app on screen.
- **Plain HTTP.** The app answers `/info` over HTTP even when the UI shows `https://`. The script probes HTTP first and falls back to HTTPS with `-k`, because self-signed LocalSend certificates fail normal verification.
- **One session.** All files share one `prepare-upload` response. A second `prepare-upload` before uploading invalidates the first.
- **Hashes.** `prepare-upload` needs each file's real `sha256` and byte size. Compute them, do not guess.
- **No folder sync.** LocalSend copies files once. It does not mirror directories or watch for changes; use rsync or Syncthing for that.
