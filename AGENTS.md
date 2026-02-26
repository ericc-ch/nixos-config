This codebase will outlive you. Every shortcut you take becomes someone else's burden. Every hack compounds into technical debt that slows the whole team down.

You are not just writing code. You are shaping the future of this project. The patterns you establish will be copied. The corners you cut will be cut again.

Fight entropy. Leave the codebase better than you found it.

## Hostname

Check which machine you're on to know which configs to modify:

```bash
cat /etc/hostname
```

This determines which files in `./home/` and `./hosts/` are relevant.

## Home Manager

Home Manager is installed as a NixOS module (see `flake.nix`), NOT standalone.

- User config: `./home/*.nix` (per-machine) and `./home/shared.nix` (shared), imported via `home-manager.users.erickc`
- Apply changes: `sudo nixos-rebuild switch --flake .#<hostname>` (NOT `home-manager switch`)
- Never run rebuild commands yourself—ask the user to run them.

## Helper Scripts

Located in `./scripts/`:

- `gc` — Garbage collect old generations
- `qs-dev` — Run quickshell with local config for development
- `rebuild` — Rebuild NixOS configuration
- `update` — Update flake inputs and rebuild

Prefer these helper scripts over raw commands.

## Agent Rules

- **Don't guess** — Read documentation first when unsure.
- **Verify packages** — Before adding packages, verify they exist:
  ```bash
  nix search nixpkgs <query> --json | jq -r 'keys[]'
  ```
- **Verify options** — Before using NixOS options, verify they exist:
  ```bash
  NIX_PATH="nixos-config=/home/<user>/nixos-config/hosts/<hostname>.nix:nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos" nixos-option <option.path>
  ```

## Documentation

When answering Nix/home-manager questions:

1. **Prefer source files** — Read actual source files at `/nix/var/nix/profiles/per-user/root/channels/nixos/nixos/modules/`
2. **Fetch from GitHub** — If local sources aren't available, fetch from `raw.githubusercontent.com/nix-community/home-manager/master/...`
