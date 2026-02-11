{
  config,
  pkgs,
  ...
}:

{
  home.username = "erickc";
  home.homeDirectory = "/home/erickc";

  # User packages - these are available only to your user
  home.packages = with pkgs; [
    # Example packages - add/remove what you want
    eza # Better ls
    fzf # Fuzzy finder
    ripgrep # Better grep
    btop # System monitor
    lazygit # Git TUI
    zoxide
    gh # GitHub CLI
    glab # GitLab CLI
    nodejs_24 # JavaScript runtime
    pkgs.llm-agents.opencode # AI coding assistant

    # Terminal and development tools
    kitty # Terminal emulator
    nixd # Nix language server
    nixfmt # Nix code formatter

    # Editors
    zed-editor # High-performance code editor
    neovim # Vim-based text editor

    # Browsers
    zen-browser
  ];

  programs.alacritty.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Erick Christian";
        email = "erickchristian48@gmail.com"; # Change this!
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      credential."https://github.com".helper = [
        ""
        "!${pkgs.gh}/bin/gh auth git-credential"
      ];
      credential."https://gist.github.com".helper = [
        ""
        "!${pkgs.gh}/bin/gh auth git-credential"
      ];
      credential."https://gitlab.com".helper = [
        ""
        "!${pkgs.glab}/bin/glab auth git-credential"
      ];
    };
  };

  # GitHub CLI configuration
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  # Lazygit configuration
  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
  };

  # Firefox browser
  programs.firefox = {
    enable = true;
  };

  # Fish shell configuration files
  xdg.configFile."fish" = {
    source = ./fish;
    recursive = true;
    force = true;
  };

  # Niri window manager configuration
  xdg.configFile."niri" = {
    source = ./niri;
    recursive = true;
    force = true;
  };

  # Enable Home Manager itself
  programs.home-manager.enable = true;

  # Don't change this unless you know what you're doing
  home.stateVersion = "25.11";
}
