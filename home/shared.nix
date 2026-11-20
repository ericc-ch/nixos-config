{
  pkgs,
  config,
  hex,
  ...
}:

let
  sshIdentity = "~/.ssh/id_ed25519";

  prismlauncherPkg = pkgs.prismlauncher.override {
    jdks = [ pkgs.jdk25 ];
  };

  # link repo path (relative to dotfiles/) into $HOME via an out-of-store symlink
  link =
    path:
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/${path}";

  # Fausto gruvbox-gtk-theme was dropped from nixpkgs (GTK 2 / murrine).
  # Colloid still builds GTK 3/4 and has a Gruvbox palette tweak.
  gtkTheme = {
    name = "Colloid-Orange-Dark-Gruvbox";
    package = pkgs.colloid-gtk-theme.override {
      themeVariants = [ "orange" ];
      colorVariants = [ "dark" ];
      tweaks = [ "gruvbox" ];
    };
  };

  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme.override { color = "brown"; };
  };

  # Prebuilt signed release (pkgs/hokum), not the flake's source build:
  # compiling Hokum builds Rune and the PipeWire/BlueZ bindings.
  hokum = pkgs.callPackage ../pkgs/hokum { };
in
{
  imports = [ hex.homeManagerModules.hex ];

  wayland.systemd.target = "niri.service";

  # Local dictation (replaces Handy). One process per user, supervised by
  # hex.service, which niri.service owns. No GlobalShortcuts portal on niri,
  # so Mod+H is bound in dotfiles/.config/niri/binds.kdl and drives
  # `hex dictation toggle`; the shortcut setting is unused here.
  #
  # Nix owns the service and the autostart, nothing else. Every setting left
  # undeclared here belongs to Hex's window: the GUI writes settings.json
  # itself and is never overwritten. Add keys under `settings` only for values
  # that must be pinned, since those are re-applied on each activation.
  # The transformations workspace (~/.config/hex) lives in dotfiles.
  programs.hex = {
    enable = true;
    autostart = true;
    systemdTarget = "niri.service";
    # Prebuilt signed release (pkgs/hex), not the flake's source build: the
    # flake is imported for its Home Manager module only.
    package = pkgs.callPackage ../pkgs/hex { };
    # Downloads whichever model is selected, so an autostarted Hex is ready to
    # dictate. Hex 3.2.0 also downloads one on its own first run.
    installModel = true;
  };

  home = {
    stateVersion = "26.05";

    # Bash is installed and managed, but not used interactively.
    shell.enableBashIntegration = false;

    pointerCursor = {
      enable = true;
      name = "Capitaine Cursors (Gruvbox)";
      package = pkgs.capitaine-cursors-themed;
      size = 32;
    };

    packages = with pkgs; [
      # CLI tools
      fd
      file
      bubblewrap
      unrar
      unzip

      # Clipboard & input
      wl-clipboard
      wtype

      # System tools
      bluetui
      hokum
      mission-center

      # Media & downloads
      ffmpeg
      loupe
      qbittorrent
      showtime
      shotcut
      vlc
      yt-dlp

      # Networking
      mitmproxy
      proton-vpn

      # Android
      android-tools
      scrcpy

      # GNOME apps
      d-spy
      nautilus
      file-roller
      p7zip

      # Documents
      pandoc

      # Development
      # code-cursor-fhs
      gammaray
      glab
      gitleaks
      google-cloud-sdk
      kdePackages.qtdeclarative
      nixd
      nixfmt
      uv
      zed-editor.fhs

      # Browsers
      helium-browser
      zen-browser

      # AI
      grok-bot
      # zcode
      # chatgpt
      opencode-desktop
      t3

      # Games
      prismlauncherPkg

      # Knowledge
      obsidian

      # Communication
      # zoom-us
    ];

    sessionVariables = {
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
    iconTheme = iconTheme;
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

    # Notifications (research: wiki/researches/notifications-osd.md).
    # Hokum owns org.freedesktop.Notifications (unit below); mako is off so
    # two daemons never race for the name. Card look: dotfiles/.config/hokum.

    # OSD for what Hokum doesn't draw: media keys, mic mute, and (via the
    # libinput backend below) caps/num/scroll lock. Volume and brightness
    # keys go to wpctl/brightnessctl, so Hokum's own cards show them.
    # Styled gruvbox via dotfiles/.config/swayosd/style.css. Binds call
    # swayosd-client, see niri/binds.kdl.
    swayosd = {
      enable = true;
      stylePath = "${config.xdg.configHome}/swayosd/style.css";
      topMargin = 0.9;
    };
  };

  # caps/num/scroll-lock OSD: libinput listener paired with swayosd-server
  # (same HM unit pattern as services.swayosd, bound to niri.service).
  # Runs unprivileged — the user is in the `input` group (machines/shared.nix).
  systemd.user.services.swayosd-libinput-backend = {
    Unit = {
      Description = "SwayOSD libinput backend (caps/num/scroll lock OSD)";
      PartOf = [ "swayosd.service" ];
      After = [
        config.wayland.systemd.target
        "swayosd.service"
      ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "always";
      RestartSec = "2s";
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };

  # Notifications, volume/brightness cards, sound/Bluetooth window and tray
  # (pkgs/hokum). Hokum is one process, so it starts with the session instead
  # of on the first notification: the window and tray are then reachable at
  # login. Exit status 78 means this desktop can't run it (no layer-shell, or
  # its shell keeps the notification name); don't restart on that.
  systemd.user.services.hokum = {
    Unit = {
      Description = "Hokum (notifications, sound and Bluetooth)";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
      StartLimitIntervalSec = 60;
      StartLimitBurst = 5;
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${hokum}/bin/hokum service";
      Restart = "on-failure";
      RestartPreventExitStatus = 78;
      RestartSec = "2s";
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };

  # T3 Code server. Tailscale Serve route is published by machines/shared.nix.
  systemd.user.services.t3 = {
    Unit = {
      Description = "T3 Code server";
      StartLimitIntervalSec = 300;
      StartLimitBurst = 5;
    };
    Service = {
      WorkingDirectory = "%h";
      Environment = [
        "T3CODE_HOME=${config.home.homeDirectory}/.t3"
        "T3CODE_HOST=127.0.0.1"
        "T3CODE_PORT=3773"
      ];
      ExecStart = "${pkgs.t3}/bin/t3 serve";
      Restart = "always";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # OpenCode API server. Uses the same service.json (loopback :4096 + password)
  # that the desktop app and phone client already use.
  systemd.user.services.opencode-serve = {
    Unit.Description = "OpenCode API server";
    Service = {
      Environment = [
        "PATH=%h/.local/share/mise/shims:/run/current-system/sw/bin:/usr/bin:/bin"
      ];
      ExecStart = "%h/.local/share/mise/shims/opencode serve --service";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # D-Bus activation file: if the unit is stopped, the first notification
  # starts it.
  xdg.dataFile."dbus-1/services/app.hokum.Notifications.service".source =
    "${hokum}/share/dbus-1/services/app.hokum.Notifications.service";

  # Drop old generations of this user's profile so their closures stop
  # rooting store paths. The system-wide GC only deletes the dead paths.
  # Delayed so it does not race the system GC for the daemon lock.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "1h";
    options = "--delete-older-than 14d";
  };

  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = false;
    };
    ripgrep.enable = true;
    jq.enable = true;
    tmux.enable = true;
    quickshell.enable = true;
    fzf.enable = true;
    neovim.enable = true;
    mise = {
      enable = true;
      mutableSettings = true;
      enableFishIntegration = true;
      # tools/settings live in config/mise/config.toml
      # (symlinked via xdg.configFile."mise/config.toml" below)
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ghostty = {
      enable = true;
      settings = {
        theme = "Gruvbox Dark Hard";
        window-theme = "ghostty";
        window-padding-x = 12;
        window-padding-y = 8;
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        fish_config theme choose gruvbox

        # SSH logins don't inherit the graphical keyring socket, and git ssh
        # signing needs it. Fall back quietly when the agent is not running.
        if not set -q SSH_AUTH_SOCK
            set -l sock "$XDG_RUNTIME_DIR/gcr/ssh"
            if test -S $sock
                set -gx SSH_AUTH_SOCK $sock
            end
        end
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
      enable = false;
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
    ".config/hex".source = link ".config/hex";
    ".config/hokum".source = link ".config/hokum";
    ".config/mise".source = link ".config/mise";
    ".config/niri".source = link ".config/niri";
    ".config/pnpm".source = link ".config/pnpm";
    ".config/quickshell".source = link ".config/quickshell";
    ".config/swayosd".source = link ".config/swayosd";
    ".config/vicinae".source = link ".config/vicinae";
    ".config/waybar".source = link ".config/waybar";
    ".config/zed".source = link ".config/zed";
    ".config/fish/conf.d/local.fish".source = link ".config/fish/conf.d/local.fish";
    ".config/fish/themes/gruvbox.theme".source = link ".config/fish/themes/gruvbox.theme";
    ".config/kitty/themes/gruvbox.conf".source = link ".config/kitty/themes/gruvbox.conf";
    ".config/opencode".source = link ".config/opencode";
  };
}
