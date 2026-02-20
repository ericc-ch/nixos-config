# pkgs/

This directory contains custom Nix packages that track external binaries from GitHub releases.

## Structure

Each package is a directory containing:

```
pkg-name/
├── default.nix       # Nix derivation
├── metadata.json     # Version and SRI hash
└── update.ts         # Script to fetch latest release info
```

## Update Scripts

Update scripts are Deno scripts that fetch the latest release from GitHub and write `metadata.json`.

### Guidelines

1. **Prefer transform functions over configuration flags** - Instead of adding flags like `stripVPrefix`, pass transform functions that give full control:
   - Use `getVersion: (tag) => tag.replace(/^v/, "")` not `stripVPrefix: true`
   - Use `getAssetName: (version) => ...` not `assetNameTemplate`

2. **Use the shared library** - Import from `../lib/update.ts`, don't duplicate common logic

3. **Keep update scripts declarative** - They should just configure the update behavior, not implement it

4. **Dependencies** - Only use what's already declared in `../../deno.json`

5. **Include shebang** - For direct execution: `#!/usr/bin/env -S deno run --allow-net --allow-write`

### Example

```typescript
#!/usr/bin/env -S deno run --allow-net --allow-write
import { updatePackage } from "../lib/update.ts";

await updatePackage({
  repo: "owner/repo-name",
  getAssetName: (version) => `asset-name-${version}.ext`,
  getVersion: (tag) => tag.replace(/^v/, ""),
  metadataFile: new URL("./metadata.json", import.meta.url),
});
```

### Running Updates

Update a single package:
```bash
cd pkgs/<package-name> && deno run --allow-net --allow-write update.ts
```

Update all packages:
```bash
cd pkgs && deno run --allow-read --allow-run update-all.ts
```

## Adding New Packages

1. Create directory `pkgs/<name>/`
2. Copy an existing `default.nix` as template
3. Create `update.ts` using the shared library
4. Run update script to generate `metadata.json`
5. Test the build: `nix build .#<name>`
