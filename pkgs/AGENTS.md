# pkgs/

Custom Nix packages. The _build_ is pure Nix: versions and SRI hashes are
pinned in repo (in `metadata.json` or `sources.json`), so builds are
reproducible and reviewable. Updating is semi-automated — one script
regenerates the pins from GitHub release APIs, no manual hash hunting.

## Layout

- `fx/`, `helium-browser/`, `llama-cpp/`, `t3-code/` — `default.nix` reads pinned `metadata.json`; `update.sh` regenerates it
- `zen-browser/` — vendored from `youwen5/zen-browser-flake` (rev
  `b7d4cc2778143a228675cd8bb7efdfa111638ac8`); pins live in `sources.json`
  (upstream format); `update.sh` regenerates it. See its `README.md` for
  attribution.

## Updating packages

Run `./scripts/update-pkgs.sh`. It fetches the latest GitHub release for each
package and rewrites `metadata.json`/`sources.json` with the new version and
SRI hashes (from the GitHub API digest — no downloads). Then:

1. Review the diff: `git diff pkgs/`
2. Rebuild to verify: `./scripts/rebuild.sh`

## Adding a package

Copy an existing package dir (`default.nix` + `metadata.json` + `update.sh`)
as template, adjust the asset URL/name pattern, and wire it into the overlay
in `flake.nix`.
