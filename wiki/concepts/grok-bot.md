# Grok Bot desktop package (`pkgs/grok-bot/`)

The x.ai Grok Bot desktop agent (Electron app, internal codename
"sand"). As of Aug 2026 the [launch page](https://x.ai/news/introducing-grok-bot)
only links a macOS (Apple silicon) build, but a Linux x86_64 build exists
behind the same update infrastructure.

## Source: a deb, not an AppImage

The app's update feed returns an AppImage `.zsync` URL, but that path is
403 for direct download. The deb is public:

```
https://downloads.cursor.com/grokbot/stable/<commit>/linux/x64/grok-bot_<version>_amd64.deb
```

~100 MB, standard Electron layout (`/opt/Grok Bot/`, desktop file, icons,
`app.asar`). The `update.sh` derives the deb URL from the feed URL by
rewriting the last path segment.

## Update feed (reverse-engineered)

Found in the Electron updater inside the deb
(`asar/dist/electron-main/main.cjs`, `buildUpdateRequestUrl`):

```
GET https://api2.cursor.sh/updates/api/update/{platform}/{track}/{currentVersion}/{machineId}/stable
```

- `platform` — `linux-x64` (macOS uses `darwin-arm64` etc.)
- `track` — stable maps to `sand`; also `sand-nightly`, `sand-dogfood`
- `currentVersion` — the running version; server replies 204 when current
- `machineId` — any UUID works (zeroes are fine)

Response when a newer build exists: `200` with
`{"version", "url", "productVersion", "timestamp"}` (`sha256hash` is
optional and absent in practice). Asking with a fake old version
(`0.0.0`) always returns the latest — that's how `update.sh` discovers
new releases. There is no digest API, so `update.sh` downloads the deb
(~100 MB) to compute the SRI hash.

## Packaging notes

- Unpacked with `dpkg-deb -x` + `autoPatchelfHook` (not
  `appimageTools` — see above). Electron deps are the usual gtk3/nss/
  alsa-lib/... set; taken from the deb's `Depends` plus `ldd` of the main
  binary.
- `unpackPhase` quirk: when overriding `unpackPhase` in
  `mkDerivation`, set `sourceRoot` but do **not** `cd` into it — stdenv
  already `chmod +x` + `cd`s into `$sourceRoot` right after the phase,
  and a second `cd` aborts the build.
- The desktop entry's `Exec` is rewritten to the wrapper (not the raw
  binary) so `NIXOS_OZONE_WL` flags apply when launched from the app
  launcher. The wrapper adds
  `--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations`
  when `NIXOS_OZONE_WL` is set.
- Scheme handlers `grokbot:` and `sand:` come from the deb's desktop file.

## Verified runtime behavior (NixOS, niri/Wayland)

- Chromium **sandbox works out of the box** — the namespace sandbox is
  used; no setuid `chrome-sandbox` and no `--no-sandbox` needed.
- Runs native Wayland (gpu process shows `--ozone-platform=wayland`).
- `g_settings_schema_source_lookup` warnings at startup are harmless
  glib schema noise, standard for Electron on NixOS.
- Single-instance lock: a second launch hands off to the first process.

## Updating on NixOS

The app's built-in self-updater cannot replace a read-only Nix store
path. The Nix package is the source of truth: update via
`./scripts/update-pkgs.sh` (expect the ~100 MB download), review
`git diff pkgs/grok-bot/`, rebuild.

Requires a SuperGrok (Plus/Heavy) or Cursor (Pro/Pro+/Ultra/Teams)
subscription to sign in.
