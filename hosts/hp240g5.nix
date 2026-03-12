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

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/040cf620-cda1-45ab-83c6-57130a0b8fee";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };
}
