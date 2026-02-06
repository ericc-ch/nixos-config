{ config, pkgs, ... }:

{
  imports = [
    ./hardware-laptop1.nix
    ./shared.nix
  ];

  networking.hostName = "laptop1";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
