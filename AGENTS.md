This codebase will outlive you. Every shortcut you take becomes someone else's burden. Every hack compounds into technical debt that slows the whole team down.

You are not just writing code. You are shaping the future of this project. The patterns you establish will be copied. The corners you cut will be cut again.

Fight entropy. Leave the codebase better than you found it.

## Workflow

Always explore the codebase first using grep/glob/read tools to understand the structure.

### Checking Current Hostname

Before making changes, always check which machine you're on so you know which configs to modify:

```bash
cat /etc/hostname
# or
hostnamectl | grep "Static hostname"
```

This determines which files in `./home/` and `./hosts/` are relevant for the current session.

## Home Manager Setup

Home Manager is installed as a NixOS module (see `flake.nix`), NOT standalone.

- User config is in `./home/*.nix` (per-machine) and `./home/shared.nix` (shared), imported via `home-manager.users.erickc`
- To apply changes: `sudo nixos-rebuild switch --flake .#<hostname>` (NOT `home-manager switch`)
- Never run the `sudo nixos-rebuild switch` command yourself. Always ask the user to run it.

## Resources

- Nix Language Cheat Sheet: `./docs/cheatsheet.nix` (read-only reference)

## Helper Scripts

Located in `./scripts/`:

- `gc` - Garbage collect old Nix generations (`sudo nix-collect-garbage --delete-old`)
- `qs-dev` - Run quickshell with local config for development
- `rebuild` - Rebuild NixOS configuration (`sudo nixos-rebuild switch --flake .#<hostname>`)
- `update` - Update flake inputs and rebuild

When suggesting commands, prefer using these helper scripts over raw commands.

### Context7 Library IDs

Use these with `documentation_query-docs`:

- Home Manager: `/nix-community/home-manager`
- Nix: `/nixos/nix`
- NixOS Manual: `/websites/nixos_manual_nixos_stable`
- NixOS Wiki: `/websites/wiki_nixos`

### GitHub Repos

Use these with `github_grep_searchGitHub`:

- Home Manager: `nix-community/home-manager`
- Nixpkgs: `nixos/nixpkgs`

## Agent Behavior Rules

1. Don't guess - When unsure about behavior, read the documentation first
2. Don't mutate the system - Never manually create/modify files (e.g., `touch`, `mkdir`). Declare everything in `.nix` files and let the user rebuild
3. Everything is code - This is a NixOS config. All changes must be declared in `.nix` files, not ad-hoc shell commands

## Documentation Guidelines

When answering Nix/home-manager questions:

1. ALWAYS use documentation_query-docs tool with the appropriate library ID
2. Use GitHub grep to find real-world examples from the home-manager repo
3. Never assume syntax - verify against official documentation first
