# NixOS Config

Personal NixOS configuration using flakes with Home Manager.

## Structure

```
hosts/               # NixOS system configurations
  shared.nix         # Common settings (edit this for shared changes)
  hp240g5.nix        # HP 240 G5 laptop config
  gl503ge.nix        # ASUS ROG GL503GE laptop config

hardware/            # Hardware configurations (auto-generated)
  hp240g5.nix
  gl503ge.nix

home/                # Home Manager configurations
  shared.nix         # Shared home settings
  hp240g5.nix        # HP 240 G5 home config
  gl503ge.nix        # ASUS ROG GL503GE home config

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

## Setup New Machine

After installing NixOS (via Calamares or any method):

1. **Get git and clone this repo**:

   ```bash
   nix shell nixpkgs#git
   git clone <repo-url> ~/nixos-config
   cd ~/nixos-config
   ```

2. **Copy hardware config**: `cp /etc/nixos/hardware-configuration.nix hardware/<hostname>.nix`
3. **Create `hosts/<hostname>.nix`** - set correct disk in `boot.loader.grub.device` (check with `lsblk`)
4. **Create `home/<hostname>.nix`** - machine-specific home manager config
5. **Add the new host to `flake.nix`** in the `nixosConfigurations` section
6. **Rebuild**: `sudo nixos-rebuild switch --flake .#<hostname>`
