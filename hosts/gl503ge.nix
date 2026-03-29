{ config, pkgs, ... }:

{
  imports = [
    ./shared.nix
    ../hardware/gl503ge.nix
  ];

  networking.hostName = "gl503ge";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "modesetting" ];

  services.pipewire.alsa.support32Bit = true;
}
