{
  pkgs,
  config,
  ...
}:

{
  home = {
    stateVersion = "26.05";

    pointerCursor = {
      name = "Capitaine Cursors (Gruvbox)";
      package = pkgs.capitaine-cursors-themed;
    };

    packages = with pkgs; [
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
      mitmproxy
      kdePackages.qtdeclarative

      # Desktop & GUI apps
      nautilus
      discord
      zen-browser
      helium-browser

      # AI assistants
      llm-agents.opencode
      llm-agents.pi
      llm-agents.gemini-cli
      llm-agents.openclaw
    ];

    sessionVariables = {
      OPENCODE_EXPERIMENTAL = "true";
      OPENCODE_ENABLE_EXA = "1";
    };
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

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif = [ "Ubuntu Nerd Font Propo" ];
      serif = [ "Ubuntu Nerd Font Propo" ];
    };
  };

  services = {
    syncthing.enable = true;
    polkit-gnome.enable = true;
    tailscale.enable = true;
  };

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
      interactiveShellInit = ''
        set -g fish_greeting
        fish_config theme choose gruvbox
      '';
      shellAliases = {
        c = "clear";
        l = "eza -lah";
        op = "opencode";
        zed = "zeditor";
      };
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

    gemini-cli = {
      enable = true;
      package = pkgs.llm-agents.gemini-cli;
      settings = {
        security = {
          auth = {
            selectedType = "oauth-personal";
          };
        };
        general = {
          previewFeatures = true;
          enableAutoUpdate = false;
        };
        context = {
          fileName = [ "AGENTS.md" ];
        };
        ui = {
          footer = {
            hideContextPercentage = false;
          };
          hideBanner = true;
          hideTips = true;
          showMemoryUsage = true;
          showModelInfoInChat = true;
          showStatusInTitle = true;
          theme = "Gruvbox";
          customThemes = {
            Gruvbox = {
              name = "Gruvbox";
              type = "custom";
              Background = "#1d2021";
              Foreground = "#ebdbb2";
              LightBlue = "#83a598";
              AccentBlue = "#83a598";
              AccentPurple = "#d3869b";
              AccentCyan = "#8ec07c";
              AccentGreen = "#b8bb26";
              AccentYellow = "#fabd2f";
              AccentRed = "#fb4934";
              Comment = "#7c6f64";
              Gray = "#928374";
              DiffAdded = "#32361a";
              DiffRemoved = "#3c1f1e";
              GradientColors = [
                "#83a598"
                "#d3869b"
                "#fb4934"
              ];
            };
          };
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

  xdg = {
    configFile."fish/themes/gruvbox.theme".source = ../config/fish/themes/gruvbox.theme;

    configFile."kitty" = {
      source = ../config/kitty;
      recursive = true;
      force = true;
    };

    configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/niri";
      force = true;
    };

    configFile."quickshell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/quickshell";
      force = true;
    };

    configFile."zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/zed";
      force = true;
    };

    configFile."opencode" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/opencode";
      force = true;
    };
  };
}
