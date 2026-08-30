# Notification daemon & OSD for niri

Researched 2026-08-30. Context: niri session (no notification daemon installed today
— `notify-send` currently goes nowhere), custom Quickshell panel, HM-as-module,
`wayland.systemd.target = "niri.service"` already set globally in
`home/shared.nix`, gruvbox dark theme.

## Recommendation

- **Notifications: mako** — lightest, zero wiring (D-Bus activation), still
  actively released, and the daemon niri's own docs recommend.
- **OSD: SwayOSD** — the de-facto Wayland OSD, actively released, HM module
  wires its systemd unit to `wayland.systemd.target` automatically.

Both are one-liners in `home/shared.nix`:

```nix
services = {
  # ...existing...
  mako.enable = true;    # D-Bus activated; starts on first notification
  swayosd.enable = true; # systemd user unit bound to niri.service
};
```

Optional gruvbox styling via `services.mako.settings` (writes
`~/.config/mako/config`) and `services.swayosd.stylePath` / `topMargin`.

SwayOSD needs the niri binds switched from `pamixer`/`brightnessctl` to
`swayosd-client`. Note `--output-volume raise` does not unmute (v0.3.2 added
`unmute` as its own action), so to keep the current unmute-on-raise behavior:

```kdl
XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "pamixer -u && swayosd-client --output-volume raise"; }
XF86AudioLowerVolume allow-when-locked=true { spawn-sh "swayosd-client --output-volume lower"; }
XF86AudioMute        allow-when-locked=true { spawn "swayosd-client" "--output-volume" "mute-toggle"; }
XF86MonBrightnessUp   allow-when-locked=true { spawn "swayosd-client" "--brightness" "raise"; }
XF86MonBrightnessDown allow-when-locked=true { spawn "swayosd-client" "--brightness" "lower"; }
```

Bonus over the current binds: SwayOSD also shows caps/num/scroll-lock via its
libinput listener, and media play/pause OSD via `--playerctl play-pause`
(`playerctl` is already installed system-wide).

## Candidates compared

### Notifications

| Daemon | Latest | Language/UI | Verdict for us |
| --- | --- | --- | --- |
| [mako](https://github.com/emersion/mako) | 1.11.0 (2026-03-26) | C, plain pango/cairo windows | **Pick.** Minimal deps, D-Bus activation (no service to wire), `makoctl` runtime control, HM module with `settings`. Recommended by niri docs. |
| [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) (swaync) | active (CI builds 2026, ~2.5k stars) | GTK3 + CSS + control center | Upgrade path if you later want a history panel/DND tray/widgets (buttons-grid, mpris). Heavier: GTK + at-spi, JSON + CSS config. Works on niri (layer-shell). |
| [fnott](https://codeberg.org/dnkl/fnott) | 1.8.0 (2025-07-16) | C, fcft, INI config | Minimal and maintained (slow pace). Keyboard-driven actions need a dmenu-ish helper; no history GUI. |
| [dunst](https://dunst-project.org/) | active | C, X11-first with Wayland since 1.6 | Mature but heavier config and X11 heritage; nothing it offers that mako doesn't. |
| Quickshell `NotificationServer` | built-in (docs v0.3.x) | QML | DIY: full freedesktop Notifications implementation inside our own shell (`Quickshell.Services.Notifications`, `trackedNotifications`, `tracked = true`). No extra daemon, total control — but we'd write the popup UI, timeouts, actions, persistence ourselves. Not out-of-the-box. |

### OSD (volume/brightness on-screen indicator)

| Tool | Latest | Verdict for us |
| --- | --- | --- |
| [SwayOSD](https://github.com/ErikReider/SwayOSD) | 0.3.2 (2026-06-22) | **Pick.** GTK4 + gtk4-layer-shell. Client/server: binds call `swayosd-client`, one `swayosd-server` daemon. Volume/mic/mute, brightness + keyboard backlight, lock-key indicators, media OSD. CSS + `config.toml` (`--duration`, `--top-margin`). HM module exists. |
| [wob](https://github.com/francma/wob) | 0.16 (slow) | Just a progress bar fed over a socket/pipe; no icons or labels. Minimal but cruder UX. |
| [avizo](https://github.com/heyjuvi/avizo) | 1.3 (2024-01-27) | GTK3/vala, volume/brightness/mic/caps only; slow-moving upstream. |
| niri built-in | v26.04 | **None.** niri ships no OSD and no notification daemon (community DIYs it via Waybar hacks or full shells). |

## Niri-specific notes

- niri implements `wlr-layer-shell` (v5 since 25.11), so mako/swaync/swayosd all
  render as overlay surfaces; nothing compositor-specific needed.
- niri 26.04 added `ext-background-effect` blur — layer-shell clients that
  support it (Quickshell v0.3+, future vicinae/foot/kitty/ghostty) can be
  blurred via `layer-rule` if we ever want that.
- Full Quickshell shells for niri exist ([DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell),
  [Noctalia](https://github.com/noctalia-dev/noctalia-shell)) — both bundle
  notifications + OSD, but replacing our minimal panel with a full shell is the
  opposite of what we want.
- HM modules for mako/swaync/swayosd/fnott all key off
  `wayland.systemd.target`, which `home/shared.nix` already sets to
  `niri.service` — no extra wiring. mako doesn't even use one (D-Bus
  activation via `dbus.packages`).

## Sources

- niri Important Software (notification daemon recommendation):
  https://highorderlogic.github.io/niri-docs/important-software.html
- niri Getting Started (Quickshell shells, session/portals):
  https://niri-wm.github.io/niri/Getting-Started.html
- niri v26.04 release (blur, no OSD mention): https://github.com/niri-wm/niri/releases/tag/v26.04
- niri v25.08 release (layer-shell v5 / ext-workspace context):
  https://github.com/niri-wm/niri/discussions/2317
- mako releases (1.11.0): https://github.com/emersion/mako/releases
- SwayOSD releases (0.3.2) and README (features, client args):
  https://github.com/ErikReider/SwayOSD/releases
- SwayNotificationCenter README (features, layer-shell requirement):
  https://github.com/ErikReider/SwayNotificationCenter
- fnott releases (1.8.0): https://codeberg.org/dnkl/fnott/releases
- wob: https://github.com/francma/wob · avizo releases:
  https://github.com/heyjuvi/avizo
- HM modules: mako, swaync, swayosd, fnott under
  https://github.com/nix-community/home-manager/tree/master/modules/services
- Quickshell NotificationServer docs:
  https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Notifications/NotificationServer/
