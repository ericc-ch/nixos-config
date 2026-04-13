{ pkgs, ... }:

let
  steamPkg = pkgs.steam.override {
    extraArgs = "-system-composer";
  };
in
{
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';
  boot.tmp.useTmpfs = true;

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
    ];
    shell = pkgs.fish;
  };

  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  programs = {
    niri.enable = true;
    nix-ld.enable = true;
    gamescope.enable = true;

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

  security.pki.certificateFiles = [
    ../assets/mitmproxy-ca-cert.pem
  ];

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
