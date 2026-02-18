{ pkgs, ... }:

{
  imports = [
    ./shared.nix
    ../hardware/hp240g5.nix
  ];

  networking.hostName = "hp240g5";

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
