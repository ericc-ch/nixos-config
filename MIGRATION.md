# Arch Dotfiles → NixOS Migration Checklist

**Source directory:** `~/dotfiles/`  
**Target directory:** `~/nixos-config/`

---

## Shell & Terminal

### Fish Shell

**Source files:**
- `dotfiles/fish/.config/fish/config.fish`
- `dotfiles/fish/.config/fish/functions/*.fish`
- `dotfiles/fish/.config/fish/completions/*.fish`
- `dotfiles/fish/.config/fish/conf.d/*.fish`

**Target files:**
- `nixos-config/fish/config.fish`
- `nixos-config/fish/functions/*.fish`
- `nixos-config/fish/completions/*.fish`
- `nixos-config/fish/conf.d/*.fish`

**Status:**
- [x] `config.fish` - Main configuration (synced)
  - Added: `XDG_STATE_HOME` export
  - Fixed: improved `XDG_DATA_DIRS` logic with base dirs check
- [x] `functions/c.fish` - Directory shortcut function
- [x] `functions/ls.fish` - ls alias function  
- [x] `functions/op.fish` - opencode shortcut function
- [x] `functions/up.fish` - Update system function
- [x] `functions/zed.fish` - Zed editor shortcut function
- [x] `functions/lg.fish` - Lazygit shortcut function (not needed, lazygit fish integration installed)
- [x] `completions/up.fish` - Completions for up function
- [x] `conf.d/zoxide.fish` - Zoxide initialization

**Action Required:**
- [x] ~Copy `lg.fish`~ (not needed - lazygit integration handles this)
- [x] Sync `config.fish` differences from `dotfiles/fish/.config/fish/config.fish`

---

### Kitty Terminal

**Source files:**
- `dotfiles/kitty/.config/kitty/kitty.conf`
- `dotfiles/kitty/.config/kitty/gruvbox.conf`

**Status:**
- [x] `kitty.conf` - Terminal configuration (migrated)
  - Source: `dotfiles/kitty/.config/kitty/kitty.conf`
  - Includes: Gruvbox theme, JetBrains Mono font, keybindings
- [x] `gruvbox.conf` - Gruvbox theme colors (migrated)
  - Source: `dotfiles/kitty/.config/kitty/gruvbox.conf`

**Action Required:**
- [x] Create `nixos-config/kitty/` directory
- [x] Copy `dotfiles/kitty/.config/kitty/kitty.conf` → `nixos-config/kitty/`
- [x] Copy `dotfiles/kitty/.config/kitty/gruvbox.conf` → `nixos-config/kitty/`
- [x] Add to `home.nix` via xdg.configFile

---

### Ghostty Terminal

**Source file:** `dotfiles/ghostty/.config/ghostty/config`

**Status:**
- [ ] `config` - Ghostty configuration (**MISSING**)
  - Source: `dotfiles/ghostty/.config/ghostty/config`
  - Includes: Gruvbox theme, window padding

**Action Required:**
- [ ] Create `nixos-config/ghostty/` directory
- [ ] Copy `dotfiles/ghostty/.config/ghostty/config` → `nixos-config/ghostty/`

---

## Window Manager

### Niri

**Source file:** `dotfiles/niri/.config/niri/config.kdl`

**Target file:** `nixos-config/niri/config.kdl`

**Status:**
- [x] `config.kdl` - Main niri configuration (already synced)
  - Current: `nixos-config/niri/config.kdl`
  - Source: `dotfiles/niri/.config/niri/config.kdl`

**Differences Found:**
- [x] `input.touchpad` section present (tap, natural-scroll, accel-profile "flat")

**Action Required:**
- [x] Touchpad section already present in nixos-config

---

### Waybar

**Source files:**
- `dotfiles/waybar/.config/waybar/config.jsonc`
- `dotfiles/waybar/.config/waybar/style.css`

**Status:**
- [ ] `config.jsonc` - Waybar configuration (**MISSING**)
  - Source: `dotfiles/waybar/.config/waybar/config.jsonc`
  - Layout: Left sidebar with workspaces, rotated clocks
- [ ] `style.css` - Waybar styling (**MISSING**)
  - Source: `dotfiles/waybar/.config/waybar/style.css`
  - Font: JetBrainsMono Nerd Font Mono

**Action Required:**
- [ ] Create `nixos-config/waybar/` directory
- [ ] Copy `dotfiles/waybar/.config/waybar/config.jsonc` → `nixos-config/waybar/`
- [ ] Copy `dotfiles/waybar/.config/waybar/style.css` → `nixos-config/waybar/`
- [ ] Add waybar to `home.nix` (package + xdg.configFile)

---

## Editors

### Zed

**Source file:** `dotfiles/zed/.config/zed/settings.json`

**Status:**
- [x] `settings.json` - Zed editor configuration (package installed, needs full config)
  - Source: `dotfiles/zed/.config/zed/settings.json`
  - Current: Basic default settings
  - Target: Vim mode, MiniMax AI, Gruvbox theme, JetBrains Mono font

**Action Required:**
- [ ] Create `nixos-config/zed/` directory
- [ ] Copy `dotfiles/zed/.config/zed/settings.json` → `nixos-config/zed/`
- [ ] Add to `home.nix` via xdg.configFile

---

### VS Codium

**Source files:**
- `dotfiles/vscodium/.config/VSCodium/User/settings.json`
- `dotfiles/vscodium/.config/VSCodium/User/keybindings.json`

**Status:**
- [ ] `settings.json` - VSCodium configuration (**MISSING**)
  - Source: `dotfiles/vscodium/.config/VSCodium/User/settings.json`
  - Includes:
    - JetBrains Mono font with ligatures
    - Prettier formatters for HTML/CSS/JS/TS/JSON/YAML/MD/Vue
    - TypeScript preferences
    - AI settings (Gemini, Codeium)
    - Telemetry disabled
    - Go and Fish formatters
- [ ] `keybindings.json` - VSCodium keybindings (**MISSING**)
  - Source: `dotfiles/vscodium/.config/VSCodium/User/keybindings.json`

**Action Required:**
- [ ] Create `nixos-config/vscodium/` directory structure
- [ ] Copy settings.json from dotfiles
- [ ] Copy keybindings.json from dotfiles (check if has custom bindings)
- [ ] Add vscodium to `home.nix` via programs.vscode

---

## Git Configuration

**Source file:** `dotfiles/git/.gitconfig`

**Target location:** `home.nix` (programs.git)

**Status:**
- [ ] `.gitconfig` - Git configuration (**MISSING**, partially in home.nix)
  - Source: `dotfiles/git/.gitconfig`

**Already in home.nix:**
- User info: Erick Christian / erickchristian48@gmail.com ✓
- GitHub/GitLab credential helpers via gh/glab ✓
- init.defaultBranch: main ✓
- push.autoSetupRemote: true ✓

**Missing from home.nix (from dotfiles):**
- `fetch.prune = true`
- `push.followTags = true`
- `pull.rebase = true`
- Aliases: `s = status`, `ps = push`, `pl = pull`
- SSH signing key (commented out in dotfiles)

**Action Required:**
- [ ] Add missing git settings to `home.nix` `programs.git.settings`
- [ ] Add git aliases section

---

## AI Tools

### Opencode

**Source files:**
- `dotfiles/opencode/.config/opencode/opencode.jsonc`
- `dotfiles/opencode/.config/opencode/agents/*.md`
- `dotfiles/opencode/.config/opencode/skills/*/SKILL.md`

**Status:**
- [ ] `opencode.jsonc` - Opencode configuration (**MISSING**)
  - Source: `dotfiles/opencode/.config/opencode/opencode.jsonc`
  - Config: Kimi K2.5 Pro model, MCP servers
- [ ] `agents/` - Agent prompts (**MISSING**)
  - Source: `dotfiles/opencode/.config/opencode/agents/`
  - Files: assistant.md, review.md
- [ ] `skills/` - Custom skills (**MISSING**)
  - Source: `dotfiles/opencode/.config/opencode/skills/`
  - Skills: agent-skill-writing, deep-research, editorial-writing, playwriter, product-planning, react-best-practices, web-frontend

**Action Required:**
- [ ] Create `nixos-config/opencode/` directory structure
- [ ] Copy `dotfiles/opencode/.config/opencode/opencode.jsonc` → `nixos-config/opencode/`
- [ ] Copy `dotfiles/opencode/.config/opencode/agents/` → `nixos-config/opencode/`
- [ ] Copy `dotfiles/opencode/.config/opencode/skills/` → `nixos-config/opencode/`
- [ ] Add opencode xdg.configFile entry in `home.nix`
- [ ] Note: opencode package already present via llm-agents overlay

---

### Gemini CLI

**Source file:** `dotfiles/gemini/.gemini/settings.json`

**Status:**
- [ ] `.gemini/settings.json` - Gemini CLI settings (**MISSING**)
  - Source: `dotfiles/gemini/.gemini/settings.json`

**Action Required:**
- [ ] Create `nixos-config/gemini/` directory
- [ ] Copy `dotfiles/gemini/.gemini/settings.json` → `nixos-config/gemini/`

---

## System Services

### Systemd User Services

**Source file:** `dotfiles/systemd/.config/systemd/user/polkit-gnome-authentication-agent.service`

**Status:**
- [ ] `polkit-gnome-authentication-agent.service` - Polkit auth agent (**MISSING**)
  - Source: `dotfiles/systemd/.config/systemd/user/polkit-gnome-authentication-agent.service`
  - Service: GNOME polkit authentication agent

**Action Required:**
- [ ] Create `nixos-config/systemd/` directory
- [ ] Copy service file from dotfiles
- [ ] Option A: Use xdg.configFile to place in ~/.config/systemd/user/
- [ ] Option B: Configure via home-manager `systemd.user.services`

---

## Scripts

**Source files:**
- `dotfiles/scripts/reflector.fish`
- `dotfiles/scripts/setup.sh`

**Status:**
- [ ] `scripts/reflector.fish` - Arch mirror update script (**MISSING**)
  - Source: `dotfiles/scripts/reflector.fish`
  - Note: Arch-specific (reflector), may not need on NixOS
- [ ] `scripts/setup.sh` - Setup script (**MISSING**)
  - Source: `dotfiles/scripts/setup.sh`
  - Note: Review if applicable to NixOS

**Action Required:**
- [ ] Review scripts for NixOS compatibility
- [ ] Port useful ones to `nixos-config/scripts/` if applicable

---

## Assets

**Source file:** `dotfiles/assets/debian.png`

**Status:**
- [ ] `assets/debian.png` - Desktop background (**MISSING**)
  - Source: `dotfiles/assets/debian.png`
  - Currently referenced in niri config as `~/dotfiles/assets/debian.png`

**Action Required:**
- [ ] Create `nixos-config/assets/` directory
- [ ] Copy `dotfiles/assets/debian.png` → `nixos-config/assets/`
- [ ] Update niri config path from `~/dotfiles/` to new location

## Hardware/Platform Specific

### Touchpad Configuration
- [ ] Niri config missing touchpad settings (tap, natural-scroll)

### Display Manager
- [x] Ly is configured in `shared.nix`

## Summary by Priority

### High Priority (Core workflow)

| # | Task | Status | Source File | Target Location |
|---|------|--------|-------------|-----------------|
| 1 | ~Add missing `lg.fish` function~ | ✅ Done (not needed) | `dotfiles/fish/.config/fish/functions/lg.fish` | `nixos-config/fish/functions/` |
| 2 | ~Sync `config.fish` improvements~ | ✅ Done | `dotfiles/fish/.config/fish/config.fish` | `nixos-config/fish/config.fish` |
| 3 | ~Migrate Kitty terminal config~ | ✅ Done | `dotfiles/kitty/.config/kitty/*.conf` | `nixos-config/kitty/` |
| 4 | Migrate Waybar config | `dotfiles/waybar/.config/waybar/*` | `nixos-config/waybar/` |
| 5 | Complete Zed settings | `dotfiles/zed/.config/zed/settings.json` | `nixos-config/zed/` |
| 6 | Add missing git settings | `dotfiles/git/.gitconfig` | `home.nix` programs.git |

### Medium Priority (Development tools)

| # | Task | Source File | Target Location |
|---|------|-------------|-----------------|
| 7 | Migrate VS Codium settings | `dotfiles/vscodium/.config/VSCodium/User/*.json` | `nixos-config/vscodium/` |
| 8 | Migrate Opencode config | `dotfiles/opencode/.config/opencode/*` | `nixos-config/opencode/` |
| 9 | ~Sync Niri touchpad settings~ | ✅ Done | `dotfiles/niri/.config/niri/config.kdl` | `nixos-config/niri/config.kdl` |
| 10 | Set up systemd user services | `dotfiles/systemd/.config/systemd/user/*.service` | `nixos-config/systemd/` |

### Low Priority (Nice to have)

| # | Task | Source File | Target Location |
|---|------|-------------|-----------------|
| 11 | Migrate Ghostty config | `dotfiles/ghostty/.config/ghostty/config` | `nixos-config/ghostty/` |
| 12 | Migrate Gemini CLI settings | `dotfiles/gemini/.gemini/settings.json` | `nixos-config/gemini/` |
| 13 | Copy wallpaper assets | `dotfiles/assets/debian.png` | `nixos-config/assets/` |
| 14 | Review and port useful scripts | `dotfiles/scripts/*` | `nixos-config/scripts/` |

## Migration Notes

- **Home Manager approach:** Most configs should use `xdg.configFile` or dedicated home-manager modules
- **Fish functions:** Already using directory copy approach in `home.nix`
- **Niri config:** Already using directory copy approach
- **Git config:** Already partially configured in `home.nix`, extend the existing `programs.git`
- **Kitty:** Can use `programs.kitty` home-manager module or xdg.configFile
- **Waybar:** Use `programs.waybar` home-manager module
- **Zed:** Use `programs.zed-editor` home-manager module or xdg.configFile
- **VS Codium:** Use `programs.vscode` home-manager module
- **Opencode:** Use xdg.configFile approach

## Quick Commands for Migration

```bash
# After implementing, rebuild with:
sudo nixos-rebuild switch --flake .#gl503ge

# To check what would change:
sudo nixos-rebuild build --flake .#gl503ge && nix-diff /run/current-system ./result
```
