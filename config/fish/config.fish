set -g fish_greeting
fish_config theme choose gruvbox

# XDG base directories
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache
set -q XDG_STATE_HOME || set -gx XDG_STATE_HOME $HOME/.local/state

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# opencode
set -gx OPENCODE_EXPERIMENTAL true
set -gx OPENCODE_ENABLE_EXA 1

# Add tool directories to PATH (highest priority first)
fish_add_path \
    $HOME/.local/bin
