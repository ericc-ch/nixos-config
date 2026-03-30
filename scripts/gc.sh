#!/bin/sh
# gc: Garbage collect old Nix generations and rebuild

sudo nix-collect-garbage --delete-old "$@" && ./scripts/rebuild
