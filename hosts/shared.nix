{ pkgs, ... }:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

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

  programs.niri.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
    ];
  };

  services.displayManager.ly.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # System hardware utilities
    brightnessctl
    pamixer
    wev

    # Networking
    cloudflared
  ];

  environment.variables.SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];
}
