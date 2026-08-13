{ pkgs, ... }:

let
  steamPkg = pkgs.steam.override {
    extraArgs = "-system-composer -pipewire";
  };
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';
  boot.tmp.useTmpfs = true;

  services.journald.extraConfig = ''
    SystemMaxUse=256M
    SystemMaxFileSize=32M
    RuntimeMaxUse=64M
  '';

  # Catch the next mystery session kill: who sent SIGTERM / ran loginctl.
  # Query after an incident:
  #   sudo ausearch -k sigterm -i -ts recent
  #   sudo ausearch -k session_ctl -i -ts recent
  #   sudo ausearch -m USER_END,USER_LOGOUT -i -ts recent
  # pkexec (GUI password dialog via polkit-gnome agent) for non-interactive
  # privileged commands; keeps sudo password-protected.
  security.polkit.enable = true;
  security.polkit.enablePkexecWrapper = true;

  security.auditd.enable = true;
  security.audit = {
    enable = true;
    backlogLimit = 8192;
    rules = [
      # SIGTERM via kill(2) / tkill(2) / tgkill(2) — exe= shows the sender
      "-a always,exit -F arch=b64 -S kill -F a1=15 -k sigterm"
      "-a always,exit -F arch=b64 -S tkill -F a1=15 -k sigterm"
      "-a always,exit -F arch=b64 -S tgkill -F a2=15 -k sigterm"
      "-a always,exit -F arch=b32 -S kill -F a1=15 -k sigterm"
      "-a always,exit -F arch=b32 -S tkill -F a1=15 -k sigterm"
      "-a always,exit -F arch=b32 -S tgkill -F a2=15 -k sigterm"

      # Explicit session/user terminate tooling
      "-w /run/current-system/sw/bin/loginctl -p x -k session_ctl"
    ];
  };

  system.stateVersion = "26.05";

  environment.variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  environment.systemPackages = with pkgs; [
    # Audio
    alsa-utils
    pamixer
    pavucontrol
    playerctl

    # Display
    brightnessctl
    vulkan-tools

    # Wayland
    xwayland-satellite

    # Networking / TLS
    cloudflared
    dnsmasq
    openssl

    # Virtualization
    podman-compose
    virt-viewer

    # System tools
    gcc
    gparted-full
    pciutils

    # Crypto
    monero-cli
    # Qt 5 app: the home-manager qt module sets QML2_IMPORT_PATH/QT_PLUGIN_PATH
    # with qt6 dirs, which makes its QML fail to load. Re-wrap like prismlauncher.
    (pkgs.symlinkJoin {
      name = "monero-gui-wrapped";
      paths = [ pkgs.monero-gui ];
      nativeBuildInputs = [ pkgs.qt5.wrapQtAppsHook ];
      qtWrapperArgs = [
        "--unset QML2_IMPORT_PATH"
        "--unset QT_PLUGIN_PATH"
        "--set QT_QPA_PLATFORMTHEME gtk3"
      ];
      postBuild = ''
        wrapQtApp $out/bin/monero-wallet-gui
      '';
    })
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      # "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.erickc = {
    isNormalUser = true;
    description = "Erick Christian";
    extraGroups = [
      "input"
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "render"
    ];
    shell = pkgs.fish;
  };

  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [
    "virbr0"
    "tailscale0"
  ];

  programs = {
    niri.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      vulkan-loader
    ];
    gamescope.enable = true;
    localsend.enable = true;

    fish = {
      enable = true;
      shellAliases = {
        l = null;
        ll = null;
        ls = null;
      };
    };

    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    steam = {
      enable = true;
      package = steamPkg;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.opentabletdriver.enable = true;

  # services.desktopManager.gnome.enable = true;
  services.flatpak.enable = true;
  services.displayManager.ly.enable = true;
  services.tailscale.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "erickc" ];
    };
  };

  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  programs.virt-manager.enable = true;

  fonts.fontconfig.useEmbeddedBitmaps = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    public-sans
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
}
