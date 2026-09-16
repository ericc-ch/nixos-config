# google-chrome-dev (vendored)

Google Chrome **Dev** (`google-chrome-unstable` on Linux). Dev is the
bleeding-edge Linux channel; there is no Canary Chrome for Linux.

Packaging is vendored from
[nix-community/browser-previews](https://github.com/nix-community/browser-previews)
at rev `dea5370bb8566bb3688476851d4ecfb167ccc499` (2026-09-15), to avoid a
flake input. That derivation is itself based on
[NixOS/nixpkgs `google-chrome`](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/go/google-chrome/package.nix).
Packaging license is [MIT](./LICENSE) (nixpkgs). The Chrome binary is unfree.

Pinned to the Dev channel only. Version and SRI hash live in `metadata.json`,
same as helium/chatgpt/zcode.

## Updating

`update.sh` (run via `./scripts/update-pkgs.sh`) reads Google's Linux Dev
versionhistory API, finds a Deb that is actually published, and rewrites
`metadata.json`. Review the diff, then rebuild.
