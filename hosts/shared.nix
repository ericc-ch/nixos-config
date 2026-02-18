{ pkgs, ... }:

let
  steamPkg = pkgs.steam.override {
    extraArgs = "-system-composer";
  };
in
{
  system.stateVersion = "26.05";

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

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = null;
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
    ];
  };

  programs.niri.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    package = steamPkg;
  };

  services.displayManager.ly.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  virtualisation.docker.enable = true;

  environment.variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];
}
