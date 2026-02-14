{ config, pkgs, ... }:

{
  imports = [
    ./shared.nix
  ];

  networking.hostName = "hp240g5";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
