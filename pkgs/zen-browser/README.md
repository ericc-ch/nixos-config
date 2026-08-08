# zen-browser (vendored)

Vendored from [youwen5/zen-browser-flake](https://github.com/youwen5/zen-browser-flake)
at rev `b7d4cc2778143a228675cd8bb7efdfa111638ac8` (2026-07-31), to remove the
flake input and shrink our supply-chain surface. License seems to be [unlicense](./LICENSE).

Vendored files, verbatim:

- `default.nix` — package set entry point
- `zen-browser-unwrapped.nix` — downloads the Zen release tarball, patches and wraps it
- `zen-browser.nix` — firefox wrapper around the unwrapped package
- `sources.json` — pinned version, download URL, and SRI hashes per platform

## Updating

`update.sh` (run via `./scripts/update-pkgs.sh`) fetches the latest Zen
release from the GitHub API and rewrites `sources.json` with the new version
and both platform hashes. Review the diff, then rebuild.
