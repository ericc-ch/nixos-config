#!/bin/sh
# rebuild: Rebuild NixOS configuration

if [ ! -f "flake.nix" ]; then
    echo "Error: flake.nix not found in current directory" >&2
    exit 1
fi

HOSTNAME="${1:-$(hostname)}"

exec sudo nixos-rebuild switch --flake ".#$HOSTNAME" "${@:2}" --print-build-logs
