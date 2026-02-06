{ config, pkgs, ... }:

{
  imports = [
    ./hardware-laptop2.nix
    ./shared.nix
  ];

  networking.hostName = "laptop2";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
