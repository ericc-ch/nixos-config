This codebase will outlive you. Every shortcut you take becomes someone else's burden. Every hack compounds into technical debt that slows the whole team down.

You are not just writing code. You are shaping the future of this project. The patterns you establish will be copied. The corners you cut will be cut again.

Fight entropy. Leave the codebase better than you found it.

## Workflow

Always explore the codebase first using grep/glob/read tools to understand the structure.

## Home Manager Setup

**IMPORTANT:** Home Manager is installed as a NixOS module (see `flake.nix`), NOT standalone.

- User config is in `./home.nix` and imported via `home-manager.users.erickc`
- To apply changes: `sudo nixos-rebuild switch` (NOT `home-manager switch`)

## Resources

- Nix Language Cheat Sheet: `./docs/cheatsheet.nix` (read-only reference)

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

## Documentation Guidelines

When answering Nix/home-manager questions:

1. ALWAYS use documentation_query-docs tool with the appropriate library ID
2. Use GitHub grep to find real-world examples from the home-manager repo
3. Never assume syntax - verify against official documentation first
