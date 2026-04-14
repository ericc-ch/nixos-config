# Dynamic Theming Research for NixOS + Quickshell

**Research Date**: 2026-02-17  
**Goal**: Find all options for dynamic Qt/GTK theming with matugen + quickshell wallpaper picker

---

## Executive Summary

This research maps all viable approaches for achieving dynamic, wallpaper-based theming in NixOS with the following requirements:

1. **Qt theming** (Qt5, Qt6, KDE apps like Dolphin)
2. **GTK theming** (GTK3, GTK4/libadwaita)
3. **Runtime color changes** without NixOS rebuilds
4. **Matugen integration** for Material You color generation
5. **Quickshell compatibility** for the UI layer

---

## Option 1: Matugen + Templates (RECOMMENDED)

### [2026-02-17 15:45] Matugen-Themes Ecosystem

**Source**: https://github.com/InioX/matugen-themes

**Key Points**:

- 278 stars, 49 forks - mature ecosystem
- 40+ application templates including Kvantum, Qt5ct/Qt6ct, GTK3/4
- Template-based color generation at runtime
- Supports post_hooks for app reloads

**Templates Available**:

- **Qt**: Kvantum (.kvconfig + .svg), qt5ct/qt6ct color schemes, Darkly.colors
- **GTK**: CSS files for gtk-3.0 and gtk-4.0
- **Quickshell**: Colors.qml output
- **Apps**: Alacritty, Kitty, Waybar, Fuzzel, Dunst, Mako, etc.

**Relevance**: This is the most mature solution for runtime theming without NixOS rebuilds.

---

### [2026-02-17 16:00] Matugen Configuration Pattern

**Source**: https://deepwiki.com/snowarch/quickshell-ii-niri/8.1-matugen-and-color-generation

**Key Points**:
Matugen outputs to `~/.local/state/quickshell/user/generated/`:

- `colors.json` - Primary color palette (Material You)
- `material_colors.scss` - SCSS variables for GTK themes
- Template outputs to `~/.config/` for each app

**Workflow**:

1. User selects wallpaper → triggers `matugen image <path>`
2. Matugen generates colors.json + app-specific configs
3. Apps reload via file watching or post_hook signals
4. Quickshell Appearance service watches colors.json

**Relevance**: Demonstrates production-ready integration pattern used by quickshell-ii-niri.

---

### [2026-02-17 16:15] Kvantum Template Implementation

**Source**: https://github.com/InioX/matugen-themes#kvantum

**Key Points**:

```toml
[templates.kvantum_kvconfig]
input_path = './templates/kvantum-colors.kvconfig'
output_path = '~/.config/Kvantum/matugen/matugen.kvconfig'

[templates.kvantum_svg]
input_path = './templates/kvantum-colors.svg'
output_path = '~/.config/Kvantum/matugen/matugen.svg'
```

Requires in `~/.config/Kvantum/kvantum.kvconfig`:

```ini
[General]
theme=matugen
```

**Relevance**: Kvantum requires BOTH a config file AND an SVG template for complete theming.

---

### [2026-02-17 16:30] Qt Theming via qt5ct/qt6ct

**Source**: https://github.com/InioX/matugen-themes#qt

**Key Points**:
Alternative to Kvantum using Qt Configuration Tool:

```toml
[templates.qt5ct]
input_path = 'path/to/template'
output_path = '~/.config/qt5ct/colors/matugen.conf'

[templates.qt6ct]
input_path = 'path/to/template'
output_path = '~/.config/qt6ct/colors/matugen.conf'
```

Requires in `~/.config/qt5ct/qt5ct.conf`:

```ini
[Appearance]
color_scheme_path=yourusername/.config/qt5ct/colors/matugen.conf
custom_palette=true
```

Environment variable:

```bash
QT_QPA_PLATFORMTHEME=qt6ct
```

**Relevance**: More lightweight than Kvantum, good for apps that don't need full SVG theming.

---

### [2026-02-17 16:45] GTK4/libadwaita CSS Override Strategy

**Source**: https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/css-variables.html

**Key Points**:
GTK4 apps using libadwaita CAN be themed via CSS variables:

```css
/* ~/.config/gtk-4.0/gtk.css */
@define-color accent_color #your_matugen_color;
@define-color accent_bg_color #your_matugen_color;
```

Available CSS variables:

- `--accent-bg-color`, `--accent-fg-color`
- `--headerbar-bg-color`, `--headerbar-fg-color`
- `--view-bg-color`, `--view-fg-color`
- `--card-bg-color`, `--card-fg-color`

**Limitations**:

- Cannot override ALL libadwaita styling
- Some hardcoded colors remain in GNOME apps
- Adwaita stylesheet is complex

**Relevance**: GTK4 theming is possible but limited compared to GTK3.

---

## Option 2: Stylix (Declarative, No Runtime Switching)

### [2026-02-17 17:00] Stylix Architecture Limitation

**Source**: https://github.com/nix-community/stylix/discussions/371

**Key Points**:
From Stylix maintainer (@danth):

> "`nixos-rebuild switch` / `home-manager switch` will always be necessary since all the theming is done as part of building the configuration."

**Why No Live Reload**:

- Themes generated at build time into Nix store
- Nix store is immutable - can't change at runtime
- No architecture for runtime theme switching

**Relevance**: Stylix is the wrong tool for wallpaper-based dynamic theming.

---

### [2026-02-17 17:15] Stylix Live Theme Issues

**Source**: https://github.com/nix-community/stylix/issues/447

**Key Points**:
Open feature request for light/dark toggling has 35+ upvotes but:

- "The big change Stylix would have to make is move from an architecture where the theme gets computed and stored in the Nix store, to one where multiple themes can be present at the same time and switchable during runtime"

- "This is pretty complicated" - requires essentially emulating `nixos-rebuild switch`

**Related Issues**:

- #530: Documentation request for live theme section
- #521: Discussion on preventing rebuilds

**Relevance**: Confirms Stylix requires fundamental architectural changes for runtime switching.

---

## Option 3: Vogix16 (Experimental Runtime Switching)

### [2026-02-17 17:30] Vogix16 Overview

**Source**: https://github.com/i-am-logger/vogix16

**Key Points**:

- 45 stars, released Dec 2025
- Built specifically for runtime theme switching in NixOS
- Generates themed config variations at build time
- Uses symlinks + app reload notifications at runtime

**How It Works**:

```
Build time: Generate all theme variations → Nix store
Runtime:    Switch symlinks → notify apps → no rebuild
```

**Supported Schemes**:

- vogix16 (19 themes) - semantic functional colors
- base16 (~300 themes)
- base24 (~180 themes)
- ansi16 (~450 themes)

**Reload Methods**:

- DBus
- Unix signals (SIGUSR1/2)
- Sway IPC
- Filesystem watching

**Relevance**: New project solving exactly this problem, but early alpha stage.

---

### [2026-02-17 17:45] Vogix16 NixOS Integration

**Source**: https://discourse.nixos.org/t/vogix16-runtime-theme-switching-for-nixos-without-rebuilds/72829

**Key Points**:

- Home Manager module available
- CLI tool: `vogix -s base16 -t catppuccin -v mocha`
- Polarity navigation: `vogix -v darker` / `vogix -v lighter`
- Currently alpha: "working in a vm, not battlefield tested"

**Usage**:

```nix
programs.vogix = {
  enable = true;
  scheme = "vogix16";
  theme = "aikido";
  variant = "dark";
};
```

**Relevance**: Promising but immature. GTK/Qt theming listed as future work (#148).

---

## Option 4: Home Manager Specialisations

### [2026-02-17 18:00] Specialisation-Based Theme Switching

**Source**: https://discourse.nixos.org/t/home-manager-toggle-between-themes/32907

**Key Points**:
Home Manager supports specialisations for theme switching:

```nix
specialisation.light-theme.configuration = {
  # Override all theme settings
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
};
```

**Switching**:

```bash
/home/erickc/.nix-profile/specialisation/light-theme/activate
```

**Tradeoffs**:

- ✅ Pre-built at activation time
- ✅ No runtime generation needed
- ❌ Requires rebuild when changing themes
- ❌ Double evaluation time (all themes built)
- ❌ Not truly dynamic (can't change from wallpaper)

**Relevance**: Good for manual light/dark toggle, not for automatic wallpaper theming.

---

## Quickshell Integration Patterns

### [2026-02-17 18:15] FileView for Dynamic Colors

**Source**: https://quickshell.outfoxxed.me/docs/master/types/Quickshell.Io/FileView

**Key Points**:
Quickshell's FileView supports file watching:

```qml
import Quickshell.Io

FileView {
  id: colorsFile
  path: "~/.local/state/quickshell/user/generated/colors.json"
  watchChanges: true  // Auto-reload on file change
  blockLoading: true
}

// Use in components
Rectangle {
  color: JSON.parse(colorsFile.text()).primary
}
```

**Relevance**: Quickshell can react to matugen color changes automatically.

---

### [2026-02-17 18:30] ii-niri Implementation Reference

**Source**: https://github.com/snowarch/quickshell-ii-niri

**Key Points**:
Production quickshell config with matugen integration:

- 426 stars, actively maintained
- Uses `Appearance` service wrapping matugen colors
- Apps reload via post_hooks (kitty, waybar, dunst, etc.)
- Qt apps use Kvantum + Darkly.colors
- GTK uses CSS imports

**File Structure**:

```
~/.config/
  matugen/config.toml          # Template definitions
  Kvantum/
    kvantum.kvconfig           # Points to matugen theme
    matugen/
      matugen.kvconfig         # Generated
      matugen.svg              # Generated
  gtk-3.0/
    gtk.css                    # @import 'colors.css'
    colors.css                 # Generated by matugen
  gtk-4.0/
    gtk.css                    # @import 'colors.css'
    colors.css                 # Generated by matugen
```

**Relevance**: Complete working reference implementation.

---

## Comparative Analysis

| Approach                | Runtime Switch | Qt Support      | GTK4 Support | Maturity      | Complexity |
| ----------------------- | -------------- | --------------- | ------------ | ------------- | ---------- |
| **Matugen + Templates** | ✅ Yes         | ✅ Kvantum/qtct | ⚠️ CSS Only  | ⭐⭐⭐ Mature | Medium     |
| **Stylix**              | ❌ No          | ✅ Yes          | ✅ Yes       | ⭐⭐⭐ Mature | Low        |
| **Vogix16**             | ✅ Yes         | 🚧 Planned      | 🚧 Planned   | ⭐ Alpha      | Medium     |
| **HM Specialisations**  | ⚠️ Pre-built   | ✅ Yes          | ✅ Yes       | ⭐⭐⭐ Mature | High       |

---

## Recommendations

### For Your Endgame Setup (Matugen + Quickshell)

**Primary Recommendation: Matugen + Templates**

1. **Qt Theming**: Use Kvantum
   - Install `qtstyleplugin-kvantum` (Qt5) and `qt6Packages.qtstyleplugin-kvantum`
   - Generate `.kvconfig` and `.svg` templates with matugen
   - Set `QT_STYLE_OVERRIDE=kvantum`

2. **GTK Theming**: CSS Override
   - GTK3: Full CSS control via `~/.config/gtk-3.0/gtk.css`
   - GTK4: Override libadwaita variables in `~/.config/gtk-4.0/gtk.css`

3. **Quickshell Integration**:
   - Use `FileView` with `watchChanges: true` to watch matugen output
   - Create `Colors.qml` singleton for color properties
   - Trigger matugen from wallpaper picker via QML

4. **App Reloads**:
   - Configure `post_hook` in matugen templates
   - Use signals: `pkill -SIGUSR2 waybar`, `kitty +kitten themes --reload-in=all`
   - Some apps need restart (Qt apps especially)

---

## Implementation Notes

### Matugen Home Manager Module

**Source**: https://github.com/InioX/matugen/pull/68

Matugen has a Home Manager module that supports both:

- **Declarative**: Define templates in Nix, outputs to home directory
- **Imperative**: Config in `~/.config/matugen/`, runtime generation

For dynamic theming, use imperative mode with Nix-managed templates.

---

### NixOS Qt Platform Theme Options

**Source**: https://github.com/NixOS/nixpkgs/issues/180131

Options for `QT_QPA_PLATFORMTHEME`:

- `kde` - Full KDE integration (pulls in KDE deps)
- `qt5ct`/`qt6ct` - Qt Configuration Tool (lightweight)
- `gtk2` - GTK2 style for Qt (deprecated, broken on Wayland)
- `gnome` - GNOME platform theme

Recommendation: Use `qt6ct` with Kvantum style for best theming control.

---

### Known Issues

1. **Kvantum on Qt5**: https://github.com/NixOS/nixpkgs/issues/355277
   - Themes not recognized if installed from packages
   - Solution: Use user directory `~/.config/Kvantum/`

2. **Qt6ct + Kvantum**: https://github.com/NixOS/nixpkgs/issues/239909
   - `QT_STYLE_OVERRIDE=kvantum` conflicts with qt6ct
   - Solution: Set style in qt6ct GUI, don't use env var

3. **GTK4 Theming**: Limited by libadwaita hardcoded colors
   - Some GNOME apps ignore CSS overrides
   - Adwaita-dark theme usually looks fine

---

## Files to Create

Based on research, your setup needs:

```
~/.config/
├── matugen/
│   └── config.toml              # Template definitions
├── Kvantum/
│   ├── kvantum.kvconfig         # Theme selector
│   └── matugen/                 # Generated theme files
├── gtk-3.0/
│   ├── gtk.css                  # @import colors
│   └── colors.css               # Generated by matugen
├── gtk-4.0/
│   ├── gtk.css                  # @import colors
│   └── colors.css               # Generated by matugen
├── qt5ct/
│   └── qt5ct.conf               # Color scheme path
├── qt6ct/
│   └── qt6ct.conf               # Color scheme path
└── quickshell/
    ├── shell.qml                # Your bar config
    └── Colors.qml               # Generated color properties
```

---

## Next Steps

1. Install matugen and matugen-themes templates
2. Create base matugen config with Kvantum + GTK + Quickshell templates
3. Test manual matugen run: `matugen image /path/to/wallpaper`
4. Integrate into quickshell wallpaper picker
5. Configure app reload hooks
6. Iterate on GTK4 CSS for libadwaita apps

---

## Sources Summary

- Matugen: https://github.com/InioX/matugen
- Matugen Themes: https://github.com/InioX/matugen-themes
- ii-niri (reference impl): https://github.com/snowarch/quickshell-ii-niri
- monet-niri (another ref): https://github.com/n3ptune-plan3t/monet-niri
- Quickshell FileView: https://quickshell.outfoxxed.me/docs/master/types/Quickshell.Io/FileView
- Stylix Live Theme Discussion: https://github.com/nix-community/stylix/discussions/371
- Vogix16: https://github.com/i-am-logger/vogix16
- Kvantum Docs: https://github.com/tsujan/Kvantum
- Libadwaita CSS: https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/css-variables.html
