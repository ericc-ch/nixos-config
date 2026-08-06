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

  # Wrap monero-gui to isolate from Qt6 paths in home-manager profile
  monero-gui-wrapped =
    pkgs.runCommand "monero-gui-wrapped"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.monero-gui}/bin/monero-wallet-gui $out/bin/monero-wallet-gui \
          --unset QML_IMPORT_PATH \
          --unset QML2_IMPORT_PATH
      '';
in
{
  wayland.systemd.target = "niri.service";

  home = {
    stateVersion = "26.05";

    pointerCursor = {
      enable = true;
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
      # matugen
      pulseaudio
      # distrobox
      mission-center
      proton-vpn
      krita
      monero-gui-wrapped
      scrcpy
      android-tools
      d-spy
      pandoc
      yt-dlp
      handy
      wtype
      mtr
      blender

      glab
      # deno
      nixd
      nixfmt
      nodejs
      zed-editor.fhs
      code-cursor-fhs
      mitmproxy
      kdePackages.qtdeclarative
      uv
      google-cloud-sdk

      nautilus
      loupe
      showtime
      discord
      qbittorrent
      vlc
      zen-browser
      helium-browser
      epiphany
      crosspipe
      prismlauncherPkg
      inkscape-with-extensions
      libreoffice
      # bruno
      firefox

      # im just gonna do global install whatever
      t3code
      # cursor-cli

      # bottles
      winePackages.stagingFull
      obsidian

      ollama-vulkan
      llama-cpp
    ];

    sessionVariables = {
      OPENCODE_EXPERIMENTAL = "true";
      OPENCODE_ENABLE_EXA = "1";
      OLLAMA_MODELS = "/mnt/hdd/ollama";
      HF_HOME = "/mnt/hdd/huggingface";
      NODE_PATH = "$HOME/.npm/lib/node_modules";
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
      "$HOME/.deno/bin"
      "$HOME/.bun/bin"
      "$PNPM_HOME/bin"
    ];
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
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
    awww.enable = true;
  };

  programs = {
    home-manager.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    quickshell.enable = true;
    fzf.enable = true;
    bun.enable = false;
    neovim.enable = true;
    npm = {
      enable = true;
      package = pkgs.nodejs;
    };

    ghostty = {
      enable = false;
      settings = {
        theme = "iTerm2 Pastel Dark Background";
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
        oc = "opencode attach http://localhost:4096 --dir \"$PWD\"";
        ocs = "opencode serve --hostname 0.0.0.0 --port 4096 --print-logs 2>&1";
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

    configFile."fish/themes/gruvbox.theme" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/fish/themes/gruvbox.theme";
    };

    configFile."kitty/themes/gruvbox.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/kitty/gruvbox.conf";
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

    configFile."pnpm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/pnpm";
      recursive = true;
    };

    configFile."matugen" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/matugen";
    };

    configFile."waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/waybar";
    };
  };
}
