{ pkgs, ... }:

let
  steamPkg = pkgs.steam.override {
    extraArgs = "-system-composer -pipewire";
  };
in
{
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';
  boot.tmp.useTmpfs = true;

  services.journald.extraConfig = ''
    SystemMaxUse=64M
    SystemMaxFileSize=16M
    RuntimeMaxUse=32M
  '';

  system.stateVersion = "26.05";

  environment.variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  environment.systemPackages = with pkgs; [
    gparted-full
    brightnessctl
    pamixer
    wev

    xwayland-satellite
    podman-compose

    virt-viewer
    dnsmasq

    cloudflared
    openssl
    vulkan-tools

    steamPkg.run

    alsa-utils
    pavucontrol

    pciutils
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
