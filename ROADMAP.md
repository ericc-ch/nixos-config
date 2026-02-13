# Home Manager Configuration Roadmap

## Potential Improvements Using `config` Parameter

### 1. Editable Configs for Active Development

Use `config.lib.file.mkOutOfStoreSymlink` for configurations that are actively being tweaked. This allows editing without rebuilding.

**Candidates for editable symlinks:**
- `kitty` - Terminal config changes frequently during customization
- `zed` - Editor settings, keybindings, themes
- `fish` - Shell functions, prompt tweaks, aliases
- `neovim` (if/when added to HM config)

**Keep in nix store (immutable):**
- `niri` - Window manager, likely stable once configured
- `opencode` - Agent config, doesn't change often

```nix
{
  config,
  pkgs,
  ...
}:

{
  # Editable - change without rebuilding
  xdg.configFile."kitty" = {
    source = config.lib.file.mkOutOfStoreSymlink ./kitty;
    recursive = true;
  };
  
  # Immutable - requires rebuild to change
  xdg.configFile."niri" = {
    source = ./niri;
    recursive = true;
    force = true;
  };
}
```

### 2. DRY: Reference Config Values

Use `config.xdg.configHome`, `config.home.homeDirectory`, etc. instead of hardcoding paths.

```nix
home.sessionVariables = {
  XDG_CONFIG_HOME = config.xdg.configHome;
};
```

### 3. Conditional Configuration

Enable packages or settings based on other enabled programs:

```nix
home.packages = with pkgs; [
  eza
  fzf
] ++ lib.optionals config.programs.fish.enable [
  fishPlugins.done
];
```

## When to Implement

- [ ] Make frequently-edited configs editable
- [ ] Refactor hardcoded paths to use `config.*`
- [ ] Add conditional package installation

## Resources

- Home Manager docs: `config.lib.file.mkOutOfStoreSymlink`
- Context7: `/nix-community/home-manager`
