# NixOS Config

## Structure

```
shared.nix           # Common settings (edit this for shared changes)
laptop1.nix          # Machine 1 config
laptop2.nix          # Machine 2 config
hardware-laptop1.nix # Hardware scan (auto-generated, don't edit)
hardware-laptop2.nix # Hardware scan (auto-generated, don't edit)
flake.nix            # System definitions
home.nix             # Home Manager config
```

## Apply Config

```bash
# On laptop1:
sudo nixos-rebuild switch --flake .#laptop1

# On laptop2:
sudo nixos-rebuild switch --flake .#laptop2
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

# 4. Install
sudo nixos-install --root /mnt --flake .#laptop1  # or .#laptop2

# 5. Reboot and rebuild after first boot
sudo nixos-rebuild switch --flake .#laptop1
```

## Setup New Machine

1. Generate hardware config: `sudo nixos-generate-config --show-hardware-config > hardware-laptop2.nix`
2. Update `laptop2.nix` - set correct disk in `boot.loader.grub.device` (check with `lsblk`)
3. Edit `flake.nix` if adding a new hostname
4. Rebuild: `sudo nixos-rebuild switch --flake .#laptop2`
