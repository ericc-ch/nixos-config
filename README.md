# NixOS Config

## Structure

```
flake.nix            # System definitions with machine configurations
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
docs/
  cheatsheet.nix     # Nix language reference
```

## Apply Config

```bash
# On hp240g5 (HP 240 G5):
sudo nixos-rebuild switch --flake .#hp240g5

# On gl503ge (ASUS ROG GL503GE):
sudo nixos-rebuild switch --flake .#gl503ge
```

Or use the helper scripts:

```bash
# Rebuild (must be run from repo root)
./scripts/rebuild <hostname>     # e.g., ./scripts/rebuild hp240g5

# Update flake inputs and rebuild
./scripts/update <hostname>

# Garbage collect old generations
./scripts/gc
```

## Fresh Install

```bash
# 1. Get git
nix shell nixpkgs#git

# 2. Clone this repo
git clone <repo-url> /mnt/etc/nixos
cd /mnt/etc/nixos

# 3. Generate hardware config
sudo nixos-generate-config --root /mnt

# 4. Install (replace <hostname> with hp240g5 or gl503ge)
sudo nixos-install --root /mnt --flake .#<hostname>

# 5. Reboot and rebuild after first boot
sudo nixos-rebuild switch --flake .#<hostname>
```

## Setup New Machine

1. Generate hardware config: `sudo nixos-generate-config --show-hardware-config > hardware/<hostname>.nix`
2. Create `hosts/<hostname>.nix` - set correct disk in `boot.loader.grub.device` (check with `lsblk`)
3. Create `home/<hostname>.nix` - machine-specific home manager config
4. Add the new host to `flake.nix` in the `nixosConfigurations` section
5. Rebuild: `sudo nixos-rebuild switch --flake .#<hostname>`
