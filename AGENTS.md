Check hostname with `cat /etc/hostname` to determine which `./home/` and `./hosts/` files to modify.

## Home Manager

Installed as NixOS module (see `flake.nix`), NOT standalone. Apply with `sudo nixos-rebuild switch --flake .#<hostname>`. Never run rebuild commands yourself—ask the user.

## Helper Scripts

In `./scripts/`: `gc`, `qs-dev`, `rebuild`, `update`. Prefer these over raw commands.

## Rules

- Don't guess—read docs first
- Verify packages: `nix search nixpkgs <query> --json | jq -r 'keys[]'`
- Verify options: `nixos-option <option.path>` (with proper NIX_PATH)

## Documentation

Prefer source files at `/nix/var/nix/profiles/per-user/root/channels/nixos/nixos/modules/`. For home-manager, fetch from `raw.githubusercontent.com/nix-community/home-manager/master/...`