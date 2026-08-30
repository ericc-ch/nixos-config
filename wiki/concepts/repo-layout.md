# Repo layout

NixOS flake config for two machines (`hp240g5`, `gl503ge`), defined in
`flake.nix` via a `mkMachine` helper that composes the same modules for
each.

## System config

- `machines/shared.nix` — system-wide base every machine imports (boot,
  security/audit rules, nix settings, users, services, fonts).
- `machines/<hostname>/default.nix` — per-machine deltas only.
- `machines/<hostname>/hardware.nix` — regenerable hardware config:
  overwrite freely with `nixos-generate-config`; keep policy decisions in
  `default.nix`, not here.

## Home config

- Home Manager is installed as a NixOS module (see `flake.nix`), NOT
  standalone.
- `home/shared.nix` — shared home packages and session variables for all
  machines.

## Dotfiles

- `dotfiles/` mirrors `$HOME` 1:1, stow-style. `home/shared.nix` links
  most directories whole, so tool writes — including atomic
  replace-rename writes — land directly in the repo; `opencode`, `fish`,
  and `kitty` are linked per-file instead.
- New files under a dir-linked directory are picked up automatically.
- Keep runtime junk out of git via the root `.gitignore`.

## Secrets

- `dotfiles/.config/fish/conf.d/local.fish` holds machine-local keys and
  is gitignored — never commit it.
- A gitleaks pre-commit hook runs from `.git/hooks/`. The tracked source
  is `.githooks/pre-commit`; new clones must run
  `cp .githooks/pre-commit .git/hooks/pre-commit`.

## Helper scripts (`scripts/`)

Prefer these over raw commands:

- `rebuild.sh [host]` — `sudo nixos-rebuild switch --flake .#<host>`
- `update.sh` — flake input updates
- `update-pkgs.sh` — regenerate `pkgs/*` metadata (see
  [packaging.md](packaging.md))
- `gc.sh` — garbage collection
- `qs-dev.sh` — quickscope dev helper
