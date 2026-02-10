{ config, pkgs, ... }:

{
  imports = [
    ./shared.nix
  ];

  networking.hostName = "gl503ge";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
