{ pkgs, ... }:

{
  imports = [
    ./shared.nix
    ../hardware/gl503ge.nix
  ];

  networking.hostName = "gl503ge";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pavucontrol
  ];

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/040cf620-cda1-45ab-83c6-57130a0b8fee";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };
}
