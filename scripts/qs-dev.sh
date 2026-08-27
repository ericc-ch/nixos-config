#!/bin/sh
# qs-dev: run the repo quickshell config. Pass -g / --gammaray to launch under GammaRay.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
config="$root/dotfiles/.config/quickshell"

if [ ! -f "$config/shell.qml" ]; then
    echo "qs-dev: missing $config/shell.qml" >&2
    exit 1
fi

use_gammaray=0
case "${1:-}" in
    -g|--gammaray)
        use_gammaray=1
        shift
        ;;
esac

if [ "$use_gammaray" -eq 1 ]; then
    exec gammaray quickshell -p "$config" "$@"
fi

exec quickshell -p "$config" "$@"
