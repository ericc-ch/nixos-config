Custom Nix packages with in-repo pins (version + SRI hash) and one
`update.sh` per package.

- Conventions, layout, and per-package quirks: [../wiki/concepts/packaging.md](../wiki/concepts/packaging.md)
- Update: `./scripts/update-pkgs.sh`, review `git diff pkgs/`, verify with `./scripts/rebuild.sh`
