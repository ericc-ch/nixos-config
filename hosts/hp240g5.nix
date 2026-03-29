{ pkgs, ... }:

{
  imports = [
    ./shared.nix
    ../hardware/hp240g5.nix
  ];

  networking.hostName = "hp240g5";

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    # intel-media-sdk
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "intel-media-sdk-23.2.2"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/00d96e26-2e5e-4a24-95e1-74e4010afdd0";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };
}
