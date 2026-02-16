#!/bin/sh
# qs-dev: Run quickshell with local config for development

if [ ! -f "flake.nix" ]; then
    echo "Error: flake.nix not found in current directory" >&2
    exit 1
fi

config_dir="./config/quickshell"
exec quickshell -p "$config_dir" "$@"
