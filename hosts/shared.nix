{ pkgs, config, ... }:

let
  steamPkg = pkgs.steam.override {
    extraArgs = "-system-composer";
  };
in
{
  system.stateVersion = "26.05";

  environment.variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  environment.systemPackages = with pkgs; [
    # System hardware utilities
    brightnessctl
    pamixer
    wev

    xwayland-satellite

    # Networking
    cloudflared
    openssl

    # Steam FHS environment for running proprietary games
    steamPkg.run

    # Audio utilities
    alsa-utils
    pavucontrol

    # Hardware info
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
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.erickc = {
    isNormalUser = true;
    description = "Erick Christian";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

  networking.networkmanager.enable = true;

  programs = {
    niri.enable = true;
    gamescope.enable = true;

    fish = {
      enable = true;
      shellAliases = {
        l = null;
        ll = null;
        ls = null;
      };
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
      ];
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

  services.displayManager.ly.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  virtualisation.docker.enable = true;

  security.pki.certificateFiles = [
    ../certs/mitmproxy-ca-cert.pem
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];
}
