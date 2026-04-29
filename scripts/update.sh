#!/bin/sh
# update: bump flake inputs + `nixos-rebuild boot` (activates after reboot). Live switch: ./scripts/rebuild.sh

if [ ! -f "flake.nix" ]; then
    echo "Error: flake.nix not found in current directory" >&2
    exit 1
fi

HOSTNAME="${1:-$(hostname)}"

deno run --allow-read --allow-run pkgs/update-all.ts
sudo nix flake update &&
    exec sudo nixos-rebuild boot --flake ".#$HOSTNAME" "${@:2}" --print-build-logs
