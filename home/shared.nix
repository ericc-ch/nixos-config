{
  pkgs,
  config,
  ...
}:

let
  prismlauncherPkg = pkgs.prismlauncher.override {
    jdks = [ pkgs.jdk21 ];
  };
in
{
  wayland.systemd.target = "niri.service";

  home = {
    stateVersion = "26.05";

    pointerCursor = {
      name = "Capitaine Cursors (Gruvbox)";
      package = pkgs.capitaine-cursors-themed;
    };

    packages = with pkgs; [
      file
      unzip
      wl-clipboard
      bluetui
      unrar
      inxi
      ffmpeg_7-full
      matugen
      distrobox
      mission-center

      # We are using home manager swww for now
      # awww

      glab
      deno
      nixd
      nixfmt
      nodejs_24
      pnpm
      zed-editor.fhs
      code-cursor-fhs
      mitmproxy
      kdePackages.qtdeclarative
      uv

      nautilus
      loupe
      showtime
      discord
      qbittorrent
      vlc
      zen-browser
      helium-browser
      prismlauncherPkg
      inkscape-with-extensions

      # im just gonna do global install whatever
      # opencode
      # llm-agents.opencode
      # llm-agents.pi
      # llm-agents.gemini-cli
      cursor-cli

      bottles
      winePackages.stagingFull
      obsidian

      ollama-vulkan
    ];

    sessionVariables = {
      OPENCODE_EXPERIMENTAL = "true";
      OPENCODE_ENABLE_EXA = "1";
      OLLAMA_MODELS = "/mnt/hdd/ollama";
      NODE_PATH = "$HOME/.npm/lib/node_modules";
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
      "$HOME/.bun/bin"
      "$PNPM_HOME"
    ];
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
      sansSerif = [ "Public Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  services = {
    syncthing.enable = true;
    polkit-gnome.enable = true;
    swww.enable = true;
  };

  programs = {
    home-manager.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    quickshell.enable = true;
    fzf.enable = true;
    bun.enable = true;
    neovim.enable = true;
    npm.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        fish_config theme choose matugen
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

    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font Mono";
        size = 12;
      };
      keybindings = {
        "ctrl+shift+t" = "new_tab_with_cwd";
      };
      settings = {
        window_padding_width = "4 12";
        hide_window_decorations = true;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
      };
      extraConfig = "include themes/matugen.conf";
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
      enable = false;
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

    waybar = {
      enable = true;
      systemd = {
        enable = true;
        targets = [ "niri.service" ];
      };
    };

    vicinae = {
      enable = true;
      systemd = {
        enable = true;
        target = "niri.service";
      };
    };
  };

  home.file = {
    ".agents" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/agents";
    };
    ".pi/agent" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/pi/agent";
    };
  };

  xdg = {
    configFile."fish/conf.d/local.fish" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/fish/conf.d/local.fish";
    };

    configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/niri";
    };

    configFile."quickshell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/quickshell";
    };

    configFile."zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/zed";
      recursive = true;
    };

    configFile."opencode" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/opencode";
    };

    configFile."matugen" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/matugen";
    };

    configFile."waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/waybar";
    };
  };
}
