# Packaging custom Nix packages (`pkgs/`)

Custom packages built with pure Nix: versions and SRI hashes are pinned
in-repo, so builds are reproducible and reviewable. Updating is
semi-automated — one script per package regenerates the pins, no manual
hash hunting.

## Conventions

Each package directory contains:

- `default.nix` — the derivation; reads its pinned metadata file
- `metadata.json` (or `sources.json`) — pinned version, URL, and SRI hash
- `update.sh` (executable) — regenerates the metadata from upstream

Packages are wired into the overlay in `flake.nix`:

```nix
<name> = prev.callPackage ./pkgs/<name> { };
```

## Layout

- `helium-browser/` — GitHub-release based. `update.sh` takes the version
  and asset digest from the GitHub API (no downloads needed to hash), then
  writes `metadata.json`. The package is an AppImage wrapped with
  `appimageTools.wrapType2`.
- `zen-browser/` — vendored from `youwen5/zen-browser-flake` (rev
  `b7d4cc2778143a228675cd8bb7efdfa111638ac8`); pins live in `sources.json`
  (upstream format); `update.sh` regenerates it. See its `README.md` for
  attribution.
- `grok-bot/` — not on GitHub releases; its updater discovers new builds
  from the app's own update feed and hashes the deb by downloading it.
  See [grok-bot.md](grok-bot.md).

## Updating packages

```sh
./scripts/update-pkgs.sh   # runs every pkgs/*/update.sh
git diff pkgs/             # review the new pins
./scripts/rebuild.sh       # verify the build
```

## Adding a package

Copy an existing package dir (`default.nix` + `metadata.json` +
`update.sh`) as template, adjust the asset URL/name pattern, and wire it
into the overlay in `flake.nix`.

## Building a package standalone

Overlay packages are not flake outputs, so `nix build .#<name>` does not
work. Build one directly with the flake's pinned nixpkgs:

```sh
NIXPKGS_ALLOW_UNFREE=1 nix build --impure --out-link /tmp/result --expr \
  '(builtins.getFlake (toString ./.)).inputs.nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/<name> { }'
```

`NIXPKGS_ALLOW_UNFREE=1` is only needed for unfree packages (the machine
configs already set `allowUnfree`); `--impure` is required because the
flake is path-based and unlocked.
