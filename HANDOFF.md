# Handoff: NixOS config architecture review

## Goal

Review `nixos-config` for unnecessary abstraction and simplification opportunities. User is not experiencing specific pain — exploring whether the config can be flatter and easier to reason about.

## What happened this session

1. **Initial question:** Should Home Manager be removed?
   - Conclusion: HM adds real value here (user systemd units, tool modules, session env, gtk/qt), but much of `home/shared.nix` is just symlink wiring and package lists that could live elsewhere. **Not the main simplification target.** User agreed to stop focusing on HM specifically.

2. **Architecture review** (`/improve-codebase-architecture`): Nine candidates proposed. **No code changes made.** User has not yet picked which to explore.

## Repo shape (quick reference)

| Path | Role |
|------|------|
| `flake.nix` | `mkMachine` helper, overlays, HM NixOS module wiring |
| `hosts/shared.nix` | System-wide config (~170 lines) |
| `hosts/{gl503ge,hp240g5}.nix` | Per-machine system overrides |
| `hardware/{gl503ge,hp240g5}.nix` | Disk UUIDs, kernel modules, boot |
| `home/shared.nix` | User config (~350 lines): packages, programs, xdg symlinks |
| `home/{gl503ge,hp240g5}.nix` | Tiny per-machine package additions (3–12 lines each) |
| `config/` | Live-edited dotfiles, symlinked into `$HOME` via `mkOutOfStoreSymlink` |
| `pkgs/` | Custom packages (`opencode`, `helium-browser`) + Deno update scripts |
| `scripts/` | `rebuild.sh`, `update.sh`, `gc.sh`, `qs-dev.sh` |

**Machines:** `gl503ge` (current), `hp240g5`. Single user: `erickc`.

**Apply changes:** `sudo nixos-rebuild switch --flake .#<hostname>` or `./scripts/rebuild.sh` — agent should not run rebuilds (see `AGENTS.md`).

## Architecture candidates (pick one to start)

User was asked **"Which of these would you like to explore?"** — no answer yet.

1. **Three parallel per-machine trees** — `hosts/`, `home/`, `hardware/` each have tiny per-host files; consider consolidating or a clearer rule for what goes where.

2. **No package placement rule** — split across `environment.systemPackages`, `home.packages`, and flake overlays with no consistent logic.

3. **Dotfile symlink repetition** — ~15 near-identical `mkOutOfStoreSymlink` blocks in `home/shared.nix`; candidate for a single list + helper.

4. **Disk mounts inconsistent** — `gl503ge` `/mnt/hdd` in `hardware/gl503ge.nix`; `hp240g5` `/mnt/hdd` in `hosts/hp240g5.nix`. `home/shared.nix` hardcodes `/mnt/hdd/ollama` and `/mnt/hdd/huggingface`.

5. **Fish split across system + user** — `programs.fish` in both `hosts/shared.nix` (enable + null aliases) and `home/shared.nix` (real config).

6. **flake.nix overlay catch-all** — third-party flakes, `pkgs-stable` pins (`mitmproxy`), custom pkgs, commented experiments in one block.

7. **`config/` mixed concerns** — hand-edited dotfiles, matugen-generated output (gitignored), `opencode/node_modules`, pi agent sessions, skills possibly duplicating `~/.agents/skills`.

8. **`pkgs/` update tooling** — assessed as **in good shape**; no urgent change.

9. **`scripts/uninstall-vp.sh`** — one-off bash unrelated to declarative config; delete or document if unused.

## Uncommitted / untracked (from session start)

- `hosts/shared.nix` — modified (not reviewed in detail this session)
- `config/pi/agent/extensions/llama-cpp.ts` — untracked
- `HANDOFF.md` — this file (replaces prior Intel GPU handoff; recover old content from git history if needed)

## Suggested next session

1. Ask user which architecture candidate(s) to tackle (or propose starting with **#3 symlink helper** or **#4 mount locality** — small, low-risk wins).
2. Implement chosen simplification with minimal diff; do not scope-creep into HM removal unless user asks.
3. If user returns to Intel GPU / SYCL work, prior handoff content is in git history for this file (pre–Jun 17 2026).

## Key files to read first

- `flake.nix`
- `hosts/shared.nix`, `hosts/gl503ge.nix`
- `home/shared.nix`
- `hardware/gl503ge.nix`, `hardware/hp240g5.nix`
- `AGENTS.md`
