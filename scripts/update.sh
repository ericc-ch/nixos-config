#!/bin/sh
# update: bump the pinned pkgs/* metadata and/or the flake inputs.
#   ./scripts/update.sh           pkgs/*, flake.lock, then `nixos-rebuild boot`
#   ./scripts/update.sh pkgs      pkgs/* metadata only — review `git diff`, then rebuild
#   ./scripts/update.sh flake     flake.lock only (nixpkgs, home-manager, hex)
#
# A second argument names the host to rebuild (default: this machine).
set -eu

cd "$(dirname "$0")/.."

# Each pkgs/<name>/update.sh rewrites pkgs/<name>/metadata.json (version +
# SRI hash) from its upstream release API.
update_pkgs() {
    for update in pkgs/*/update.sh; do
        [ -x "$update" ] || continue
        "$update"
    done
}

what="${1:-all}"
host="${2:-$(hostname)}"

case "$what" in
pkgs)
    update_pkgs
    ;;
flake)
    # No sudo: it writes flake.lock inside this repo, and a root-owned
    # lockfile afterwards breaks plain `nix` and `git` writes.
    exec nix flake update
    ;;
all)
    update_pkgs
    nix flake update
    exec sudo nixos-rebuild boot --flake ".#$host" --print-build-logs
    ;;
*)
    echo "usage: $0 [pkgs|flake|all] [hostname]" >&2
    exit 2
    ;;
esac
