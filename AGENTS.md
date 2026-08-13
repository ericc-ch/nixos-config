- Shared system: `./machines/shared.nix`
- Shared home: `./home/shared.nix`
- Per-machine deltas: `./machines/<hostname>/default.nix`
- Regenerable hardware: `./machines/<hostname>/hardware.nix` (overwrite with `nixos-generate-config`; put policy in `default.nix`)
- Dotfiles: `./dotfiles/` mirrors `$HOME` 1:1 (stow-style). `home/shared.nix` links most dirs whole (tool writes — including atomic replaces — land in the repo); `opencode`, `fish`, `kitty` are per-file. New files under dir-linked dirs appear automatically; keep runtime junk out of git via the root `.gitignore`.
- Secrets: `dotfiles/.config/fish/conf.d/local.fish` holds machine-local keys and is gitignored — keep it out of git. A gitleaks pre-commit hook runs from `.git/hooks/` (default location); `.githooks/pre-commit` is the tracked source — new clones: `cp .githooks/pre-commit .git/hooks/pre-commit`.

## Home Manager

Installed as NixOS module (see `flake.nix`), NOT standalone.

## Helper Scripts

In `./scripts/`: `gc.sh`, `qs-dev.sh`, `rebuild.sh`, `update.sh`. Prefer these over raw commands.
