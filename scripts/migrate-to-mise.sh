#!/usr/bin/env bash
# Migrate node/deno/bun/pnpm/npm globals from nix + self-installs to mise.
# Prereq: sudo nixos-rebuild switch --flake .#gl503ge (mise must be on PATH)
# This script is safe to run twice; old installs are moved, not deleted.
set -euo pipefail

BACKUP_DIR="$HOME/.mise-migration-backup-$(date +%Y%m%d%H%M%S)"

RUNTIMES=(
  "node@26"
  "deno@2.9.4"
  "bun@latest"
  "pnpm@11.19.0"
)

GLOBALS=(
  "playwriter@0.4.0"
  "executor@1.5.40"
  "opencode-ai@1.18.15"
  "@opencode-ai/cli@0.0.0-next-17028"
  "@earendil-works/pi-coding-agent@0.84.1"
)

OLD_DIRS=(
  "$HOME/.deno"
  "$HOME/.bun"
  "$HOME/.npm"
  "$HOME/.local/share/pnpm"
)

fail() {
  echo "✗ $1" >&2
  exit 1
}

command -v mise >/dev/null 2>&1 || fail "mise not on PATH — did you run the nixos-rebuild switch first?"

echo "== 1/5 pinning runtimes =="
mise use -g "${RUNTIMES[@]}"

echo "== 2/5 verifying runtime shims =="
for cmd in node npm deno bun pnpm; do
  path=$(mise which "$cmd" 2>/dev/null || true)
  [[ -n "$path" && "$path" == *mise* ]] && echo "  ✓ $cmd -> $path" || fail "$cmd -> ${path:-not found} (expected mise-managed path)"
done

echo "== 3/5 installing npm globals via mise =="
for pkg in "${GLOBALS[@]}"; do
  echo "  installing $pkg"
  mise use -g "npm:$pkg"
done

echo "== 4/5 verifying global bins =="
for bin in playwriter executor opencode opencode2 pi; do
  path=$(mise which "$bin" 2>/dev/null || true)
  [[ -n "$path" && "$path" == *mise* ]] && echo "  ✓ $bin -> $path" || fail "$bin -> ${path:-not found} (expected mise-managed path)"
done

echo "== 5/5 moving old installs out of the way =="
mkdir -p "$BACKUP_DIR"
for d in "${OLD_DIRS[@]}"; do
  if [[ -e "$d" ]]; then
    mv "$d" "$BACKUP_DIR/" && echo "  moved $d"
  fi
done

# neutralize the npm prefix override so plain `npm i -g` can't install to a dead dir
if [[ -f "$HOME/.npmrc" ]]; then
  cp "$HOME/.npmrc" "$BACKUP_DIR/.npmrc"
  if grep -q '^prefix=' "$HOME/.npmrc"; then
    sed -i 's|^prefix=.*$|# prefix= (removed by mise migration)|' "$HOME/.npmrc"
    echo "  neutralized prefix= in ~/.npmrc (backup in $BACKUP_DIR)"
  fi
fi

echo
echo "done. old installs kept at: $BACKUP_DIR"
echo "next: open a NEW fish shell, then verify:"
echo "  mise ls"
echo "  which node npm deno bun pnpm opencode opencode2 pi playwriter executor"
echo "  rm -rf \"$BACKUP_DIR\"   # once everything checks out"
