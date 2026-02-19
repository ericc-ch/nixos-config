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
    file
    unzip
    wl-clipboard

    # Version control
    glab

    # Development tools
    deno
    nixd
    nixfmt
    nodejs_24
    pnpm
    zed-editor.fhs

    # Desktop & GUI apps
    nautilus
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

  programs = {
    home-manager.enable = true;
    kitty.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    lazydocker.enable = true;
    quickshell.enable = true;
    fzf.enable = true;
    bun.enable = true;
    neovim.enable = true;

    fish = {
      enable = true;
      plugins = [
        {
          name = "hydro";
          src = pkgs.fishPlugins.hydro.src;
        }
      ];
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
      };
    };

    git = {
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

    lazygit = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
    };
  };

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
