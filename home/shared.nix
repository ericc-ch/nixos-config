{
  pkgs,
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
    kdePackages.qtdeclarative
    nautilus
    quickshell
    zen-browser

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

  programs.home-manager.enable = true;

  programs.kitty.enable = true;

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
  };

  services.syncthing = {
    enable = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent = {
    Unit = {
      Description = "Polkit GNOME authentication agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

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
    source = ../config/niri;
    recursive = true;
    force = true;
  };

  xdg.configFile."opencode" = {
    source = ../config/opencode;
    recursive = true;
    force = true;
  };

  xdg.configFile."quickshell" = {
    source = ../config/quickshell;
    recursive = true;
    force = true;
  };

  xdg.configFile."zed" = {
    source = ../config/zed;
    recursive = true;
    force = true;
  };
}
