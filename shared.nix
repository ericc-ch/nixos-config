{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  users.users.erickc = {
    isNormalUser = true;
    description = "Erick Christian";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.ly.enable = true;

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];
}
