{
  config,
  pkgs,
  ...
}:

{
  home.username = "erickc";
  home.homeDirectory = "/home/erickc";

  home.packages = with pkgs; [
    eza
    fzf
    ripgrep
    btop
    lazygit
    zoxide
    gh
    glab
    nodejs_24
    pnpm
    pkgs.llm-agents.opencode
    kitty
    nixd
    nixfmt
    zed-editor.fhs
    neovim
    zen-browser
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif = [ "Ubuntu Nerd Font Propo" ];
      serif = [ "Ubuntu Nerd Font Propo" ];
    };
  };

  programs.alacritty.enable = true;

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

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
    ];
  };

  programs.firefox = {
    enable = true;
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

  xdg.configFile."fish" = {
    source = ./fish;
    recursive = true;
    force = true;
  };
  xdg.configFile."niri" = {
    source = ./niri;
    recursive = true;
    force = true;
  };
  xdg.configFile."kitty" = {
    source = ./kitty;
    recursive = true;
    force = true;
  };
  xdg.configFile."zed" = {
    source = ./zed;
    recursive = true;
    force = true;
  };
  xdg.configFile."opencode" = {
    source = ./opencode;
    recursive = true;
    force = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
