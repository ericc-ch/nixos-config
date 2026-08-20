{
  pkgs,
  config,
  ...
}:

let
  sshIdentity = "~/.ssh/id_ed25519";

  prismlauncherPkg = pkgs.prismlauncher.override {
    jdks = [ pkgs.jdk25 ];
  };

  # link repo path (relative to dotfiles/) into $HOME via an out-of-store symlink
  link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/${path}";

  # Fausto gruvbox-gtk-theme was dropped from nixpkgs (GTK 2 / murrine).
  # Colloid still builds GTK 3/4 and has a Gruvbox palette tweak.
  gtkTheme = {
    name = "Colloid-Dark-Gruvbox";
    package = pkgs.colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      tweaks = [ "gruvbox" ];
    };
  };
in
{
  wayland.systemd.target = "niri.service";

  home = {
    stateVersion = "26.05";

    # Bash is installed and managed, but not used interactively.
    shell.enableBashIntegration = false;

    pointerCursor = {
      enable = true;
      name = "Capitaine Cursors (Gruvbox)";
      package = pkgs.capitaine-cursors-themed;
    };

    packages = with pkgs; [
      # CLI tools
      fd
      file
      unrar
      unzip

      # Clipboard & input
      wl-clipboard
      wtype

      # System tools
      bluetui
      mission-center

      # Media & downloads
      ffmpeg
      loupe
      qbittorrent
      showtime
      shotcut
      vlc
      yt-dlp

      # Graphics
      krita

      # Networking
      mitmproxy
      proton-vpn

      # Android
      android-tools
      scrcpy

      # GNOME apps
      d-spy
      nautilus

      # Documents
      pandoc

      # Development
      code-cursor-fhs
      glab
      gitleaks
      google-cloud-sdk
      handy
      kdePackages.qtdeclarative
      nixd
      nixfmt
      uv
      zed-editor.fhs

      # Browsers
      helium-browser
      zen-browser
      firefox-bin
      librewolf-bin

      # Communication
      # discord

      # Games
      prismlauncherPkg

      # Knowledge
      obsidian

      # AI
      fx
      llama-cpp
      ollama-vulkan
      t3-code
    ];

    sessionVariables = {
      OPENCODE_EXPERIMENTAL = "true";
      OPENCODE_ENABLE_EXA = "1";
      OLLAMA_MODELS = "/mnt/hdd/ollama";
      HF_HOME = "/mnt/hdd/huggingface";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.local/share/mise/shims"
    ];
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    kvantum = {
      enable = true;
      themes = [ pkgs.gruvbox-kvantum ];
      settings.General.theme = "Gruvbox-Dark-Brown";
    };
  };

  gtk = {
    enable = true;
    theme = gtkTheme;
    gtk4.theme = gtkTheme;
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
    awww.enable = true;
  };

  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = false;
    };
    ripgrep.enable = true;
    jq.enable = true;
    quickshell.enable = true;
    fzf.enable = true;
    neovim.enable = true;
    mise = {
      enable = true;
      enableMutableConfig = true;
      enableFishIntegration = true;
      # tools/settings live in config/mise/config.toml
      # (symlinked via xdg.configFile."mise/config.toml" below)
    };

    ghostty = {
      enable = true;
      settings = {
        theme = "GruvboxDarkHard";
        window-padding-x = 8;
        window-padding-y = 8;
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        fish_config theme choose gruvbox
      '';
      shellAliases = {
        c = "clear";
        l = "eza -lah";
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
      shellIntegration.enableBashIntegration = false;
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
      extraConfig = "include themes/gruvbox.conf";
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
      };
    };

    git = {
      enable = true;

      signing = {
        key = sshIdentity;
        signByDefault = true;
      };

      settings = {
        user = {
          name = "Erick Christian";
          email = "erickchristian48@gmail.com";
        };
        gpg.format = "ssh";
        init.defaultBranch = "main";
        fetch.prune = true;
        pull.rebase = true;
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
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

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          IdentityFile = sshIdentity;
          AddKeysToAgent = "yes";
          HashKnownHosts = true;
        };
      };
    };
  };

  # ---- dotfiles farm ----
  # dotfiles/ mirrors $HOME 1:1 (stow-style): repo path == home path.
  # Most dirs are linked as a whole — the link points at the live repo dir,
  # so tool writes (including atomic temp+rename replaces) land inside the
  # repo and the link survives. A few files are linked individually, where
  # HM modules own the dir (fish, kitty). opencode is whole-dir linked;
  # its runtime junk (node_modules, package.json, service.json, cli.json,
  # package-lock.json) lives in the repo dir but is gitignored.
  home.file = {
    ".pi".source = link ".pi";
    ".agents".source = link ".agents";
    ".gemini/config/skills".source = link ".agents/skills";
    ".config/mise".source = link ".config/mise";
    ".config/niri".source = link ".config/niri";
    ".config/pnpm".source = link ".config/pnpm";
    ".config/quickshell".source = link ".config/quickshell";
    ".config/waybar".source = link ".config/waybar";
    ".config/zed".source = link ".config/zed";
    ".config/fish/conf.d/local.fish".source = link ".config/fish/conf.d/local.fish";
    ".config/fish/themes/gruvbox.theme".source = link ".config/fish/themes/gruvbox.theme";
    ".config/kitty/themes/gruvbox.conf".source = link ".config/kitty/themes/gruvbox.conf";
    ".config/opencode".source = link ".config/opencode";
  };
}
