# pkgs/

Custom Nix packages tracking GitHub releases. Each package has `default.nix`, `metadata.json`, and `update.ts`.

## Adding Packages

1. Copy existing package directory as template
2. Run `update.ts` to generate `metadata.json`
3. Build: `nix build .#<name>`

## Development

Run `deno check` and `deno lint` after TypeScript changes.

For update script patterns, see `lib/update.ts` and existing packages like `qs-core`.
