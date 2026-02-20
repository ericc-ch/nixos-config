# Debugging AppImage Packages in Nix

When an AppImage-based Nix package fails to build, you often need to inspect the contents of the AppImage itself to understand what's happening. Here's the workflow:

## The Problem

You got an error like:

```
substituteStream() in derivation helium-0.9.2.1: ERROR: pattern Exec=AppRun doesn't match anything in file '/nix/store/.../share/applications/helium.desktop'
```

This means the `substituteInPlace` command in your `extraInstallCommands` is looking for a pattern that doesn't exist in the actual desktop file.

## The Solution

### Step 1: Fetch the AppImage

First, get the AppImage file into the Nix store (it may already be there from a previous build attempt):

```bash
# Get the version and hash from metadata.json
cd pkgs/helium-browser
version=$(jq -r '.version' metadata.json)
hash=$(jq -r '.hash' metadata.json)

# Fetch it (this puts it in the Nix store)
nix-prefetch-url \
  "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage" \
  "$hash" \
  --print-path
```

This outputs something like:
```
1z4vz3imvvzh258pqn6xbfbgmxlnaz2rxcrmnq33sf0dpwic3q42
/nix/store/dlj9kbl3pd56m5ffqqz32xwk3irld8ak-helium-0.9.2.1-x86_64.AppImage
```

The second line is the path to the AppImage in the Nix store.

### Step 2: Extract the AppImage

AppImages are squashfs images that can be extracted:

```bash
# Copy to a writable location (nix store is read-only)
cp /nix/store/dlj9kbl3pd56m5ffqqz32xwk3irld8ak-helium-0.9.2.1-x86_64.AppImage /tmp/helium.AppImage

# Make it executable and extract
chmod +x /tmp/helium.AppImage
/tmp/helium.AppImage --appimage-extract

# Now you have a squashfs-root/ directory with all the contents
ls -la squashfs-root/
```

### Step 3: Inspect the Contents

Look at what you need:

```bash
# Check the desktop file (this was failing for us)
cat squashfs-root/helium.desktop

# Look at the directory structure
find squashfs-root/ -type f | head -20

# Check what binaries are included
ls -la squashfs-root/usr/bin/ 2>/dev/null || ls -la squashfs-root/
```

### Step 4: Fix Your Derivation

Based on what you find, update your `default.nix`. In our case, the desktop file already had `Exec=helium %U` instead of `Exec=AppRun`, so we removed the unnecessary `substituteInPlace`.

## Quick Reference

### Common AppImage Extraction Issues

**Permission denied:**
```bash
# AppImages need to be writable to be executed
cp from/nix/store to/writable/location
chmod +x writable/location/appimage
```

**Finding the desktop file:**
```bash
# Desktop files are usually at the root or in usr/share/applications/
find squashfs-root/ -name "*.desktop" -type f
```

**Checking file contents:**
```bash
# Look for specific patterns
grep -r "Exec=" squashfs-root/
grep -r "Icon=" squashfs-root/
```

### Using nix-prefetch-url vs fetchurl

- `nix-prefetch-url`: Downloads to Nix store immediately, gives you the path
- `fetchurl` (in derivations): Downloads at build time, content-addressed by hash

Both put files in `/nix/store/` but `nix-prefetch-url` is useful for debugging since you get immediate access to the file.

## Why This Works

1. **AppImage format**: AppImages are self-mounting squashfs filesystems. The `--appimage-extract` flag bypasses mounting and just extracts the contents.

2. **Nix store paths**: When you reference `${contents}` in your derivation, you're referencing the extracted squashfs contents. By manually extracting, you can see exactly what your derivation sees.

3. **Fixed-output derivations**: The `hash` in your metadata ensures you get the exact same file every time. This makes debugging reproducible.

## Tips

- Always work in `/tmp/` for debugging - you can delete it when done
- The extracted squashfs-root can be large, so clean up after: `rm -rf squashfs-root/`
- If `nix-prefetch-url` says "path is already in store", that's fine - just use the existing path
- You can use `appimage-run` (from nixpkgs) to run AppImages without extracting, but extraction gives you more control for debugging
