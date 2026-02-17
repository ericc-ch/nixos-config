{ pkgs, lib, ... }:

let
  steamPkg = pkgs.steam.override {
    extraArgs = "-system-composer";
  };
in
{
  environment.systemPackages = with pkgs; [
    # System hardware utilities
    brightnessctl
    pamixer
    wev

    xwayland-satellite

    # Networking
    cloudflared

    # Steam FHS environment for running proprietary games
    steamPkg.run
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "26.05";

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

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
    config.niri = lib.mkForce {
      default = [
        "kde"
        "gtk"
      ];
    };
  };

  environment.sessionVariables = {
    # Required for Dolphin file associations to work outside of Plasma
    # See: https://github.com/NixOS/nixpkgs/issues/409986
    XDG_MENU_PREFIX = "plasma-";
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
