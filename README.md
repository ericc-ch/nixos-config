# NixOS Config

## Fresh Install

```bash
# 1. Get git
nix shell nixpkgs#git

# 2. Clone this repo
git clone <repo-url> /mnt/etc/nixos
cd /mnt/etc/nixos

# 3. Generate hardware config (creates hardware-configuration.nix)
sudo nixos-generate-config --root /mnt

# 4. Install
sudo nixos-install --root /mnt --flake .

# 5. Reboot and rebuild after first boot
sudo nixos-rebuild switch --flake .
```
