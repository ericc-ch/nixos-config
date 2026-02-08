{ config, pkgs, ... }:

{
  imports = [
    ./shared.nix
  ];

  networking.hostName = "gl503ge";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
