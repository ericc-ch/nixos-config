{
  pkgs,
  config,
  ...
}:

{
  home.username = "erickc";
  home.homeDirectory = "/home/erickc";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # System & CLI utilities
    btop
    eza
    file
    fzf
    jq
    ripgrep
    unzip
    wl-clipboard
    zoxide

    # Version control
    git
    gh
    glab
    lazygit

    # Development tools
    bun
    deno
    neovim
    nixd
    nixfmt
    nodejs_24
    pnpm
    zed-editor.fhs

    # Desktop & GUI apps
    nautilus
    quickshell
    zen-browser

    # Theming
    rose-pine-cursor

    # AI assistants
    llm-agents.opencode

    # Android reverse engineering
    apktool
    dex2jar
    jadx
  ];

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Erick Christian";
        email = "erickchristian48@gmail.com";
      };
      init.defaultBranch = "main";
      fetch.prune = true;
      pull.rebase = true;
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      credential."https://github".helper = [
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
      alias = {
        s = "status";
        ps = "push";
        pl = "pull";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.home-manager.enable = true;
  programs.kitty.enable = true;

  services.syncthing = {
    enable = true;
  };

  services.polkit-gnome.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif = [ "Ubuntu Nerd Font Propo" ];
      serif = [ "Ubuntu Nerd Font Propo" ];
    };
  };

  xdg.configFile."fish" = {
    source = ../config/fish;
    recursive = true;
    force = true;
  };

  xdg.configFile."kitty" = {
    source = ../config/kitty;
    recursive = true;
    force = true;
  };

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/niri";
    force = true;
  };

  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/quickshell";
    force = true;
  };

  xdg.configFile."zed" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/zed";
    force = true;
  };

  xdg.configFile."opencode" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/opencode";
    force = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    colorScheme = "dark";
  };

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
  };
}
