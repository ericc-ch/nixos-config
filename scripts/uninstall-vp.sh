#!/usr/bin/env bash
# Vite+ Uninstaller
# Completely removes Vite+ from your system

VITE_PLUS_HOME="$HOME/.vite-plus"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info() {
    echo -e "${BLUE}info${NC}: $1"
}

success() {
    echo -e "${GREEN}success${NC}: $1"
}

warn() {
    echo -e "${YELLOW}warn${NC}: $1"
}

remove_from_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        return 1
    fi

    if ! grep -qE "vite\.plus|viteplus|vite-plus|Vite\+" "$file" 2>/dev/null; then
        return 1
    fi

    local temp_file
    temp_file=$(mktemp)
    grep -vE "vite\.plus|viteplus|vite-plus|Vite\+" "$file" > "$temp_file" 2>/dev/null || true

    local orig_perms
    orig_perms=$(stat -c %a "$file" 2>/dev/null || stat -f %Lp "$file" 2>/dev/null || echo "644")

    mv "$temp_file" "$file"
    chmod "$orig_perms" "$file"

    sed -i '/^$/N;/^\n$/D' "$file" 2>/dev/null || true

    return 0
}

remove_fish_config() {
    local fish_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
    local fish_config="$fish_dir/vite-plus.fish"
    if [[ -f "$fish_config" ]]; then
        rm -f "$fish_config"
        return 0
    fi
    return 1
}

echo ""
echo -e "${BOLD}Vite+ Uninstaller${NC}"
echo ""

if [[ ! -d "$VITE_PLUS_HOME" ]]; then
    info "Vite+ is not installed at $VITE_PLUS_HOME"
    exit 0
fi

info "Removing Vite+ from $VITE_PLUS_HOME..."

rm -rf "$VITE_PLUS_HOME"
success "Removed installation directory"

info "Cleaning shell configuration files..."

cleaned=0

for config in "$HOME/.zshenv" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.profile"; do
    if remove_from_file "$config"; then
        success "Cleaned $config"
        ((cleaned++))
    fi
done

if remove_fish_config; then
    success "Removed fish configuration"
    ((cleaned++))
fi

if [[ $cleaned -eq 0 ]]; then
    info "No shell configurations needed cleaning"
fi

echo ""
echo -e "${GREEN}✔${NC} Vite+ has been completely removed from your system."
echo ""
echo "  You may need to restart your terminal to complete the removal."
echo ""