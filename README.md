# NixOS Config

Personal NixOS configuration using flakes with Home Manager.

## Structure

```
machines/            # Per-machine NixOS + Home Manager deltas
  shared.nix         # Common system settings (edit this for shared changes)
  gl503ge/
    default.nix      # ASUS ROG GL503GE host deltas + home packages
    hardware.nix     # Regenerable (nixos-generate-config)
  hp240g5/
    default.nix      # HP 240 G5 host deltas + home packages
    hardware.nix     # Regenerable (nixos-generate-config)

home/
  shared.nix         # Shared Home Manager settings

scripts/             # Helper scripts for common operations
  gc                 # Garbage collect old Nix generations
  qs-dev             # Run quickshell with local config for development
  rebuild            # Rebuild NixOS configuration
  update             # Update flake inputs and rebuild
```

## Helper Scripts

All scripts must be run from the repo root:

```bash
# Rebuild configuration (auto-detects hostname)
./scripts/rebuild

# Update flake inputs and rebuild
./scripts/update

# Garbage collect old generations
./scripts/gc

# Run quickshell with local config for development
./scripts/qs-dev
```

## Regenerate hardware

On the machine, with disks mounted as you want them declared:

```bash
nixos-generate-config --dir /tmp/hw --force
cp /tmp/hw/hardware-configuration.nix machines/$(hostname)/hardware.nix
```

Do not edit `hardware.nix` for policy (mount options, zram/zswap, GPU, services) — put those in `machines/<hostname>/default.nix`.

## Setup New Machine

After installing NixOS (via Calamares or any method):

1. **Get git and clone this repo**:

   ```bash
   nix shell nixpkgs#git
   git clone <repo-url> ~/nixos-config
   cd ~/nixos-config
   ```

2. **Create machine dir and copy hardware**:

   ```bash
   mkdir -p machines/<hostname>
   nixos-generate-config --dir /tmp/hw --force
   cp /tmp/hw/hardware-configuration.nix machines/<hostname>/hardware.nix
   ```

3. **Create `machines/<hostname>/default.nix`** — hostname, machine-specific system options, and `home-manager.users.erickc` extras (import `../../home/shared.nix`)
4. **Add the new host to `flake.nix`** in the `nixosConfigurations` section
5. **Rebuild**: `sudo nixos-rebuild switch --flake .#<hostname>`
