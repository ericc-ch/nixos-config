{ config, pkgs, ... }:

{
  imports = [
    ./shared.nix
    ../hardware/gl503ge.nix
  ];

  networking.hostName = "gl503ge";

  nixpkgs.config.cudaSupport = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  services.pipewire.alsa.support32Bit = true;

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/040cf620-cda1-45ab-83c6-57130a0b8fee";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };
}
