Check hostname with `cat /etc/hostname` to determine which `./machines/<hostname>/` files to modify.

- Shared system: `./machines/shared.nix`
- Shared home: `./home/shared.nix`
- Per-machine deltas: `./machines/<hostname>/default.nix`
- Regenerable hardware: `./machines/<hostname>/hardware.nix` (overwrite with `nixos-generate-config`; put policy in `default.nix`)
- Dotfiles: `./dotfiles/` mirrors `$HOME` 1:1 (stow-style). `home/shared.nix` links most dirs whole (tool writes — including atomic replaces — land in the repo); `opencode`, `fish`, `kitty` are per-file. New files under dir-linked dirs appear automatically; keep runtime junk out of git via the root `.gitignore`.

## Home Manager

Installed as NixOS module (see `flake.nix`), NOT standalone. Per-machine HM entry is `home-manager.users.erickc` in `machines/<hostname>/default.nix`. Apply with `sudo nixos-rebuild switch --flake .#<hostname>`. Never run rebuild commands yourself—ask the user.

## Helper Scripts

In `./scripts/`: `gc.sh`, `qs-dev.sh`, `rebuild.sh`, `update.sh`. Prefer these over raw commands.

## Rules

- Don't guess—read docs first
- Verify packages: `nix search nixpkgs <query> --json | jq -r 'keys[]'`
- Verify options: `nixos-option <option.path>` (with proper NIX_PATH)

## Documentation

Prefer source files at `/nix/var/nix/profiles/per-user/root/channels/nixos/nixos/modules/`. For home-manager, fetch from `raw.githubusercontent.com/nix-community/home-manager/master/...`
