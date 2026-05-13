{ pkgs, ... }:

{
  imports = [
    ./shared.nix
    ../hardware/gl503ge.nix
  ];

  networking.hostName = "gl503ge";

  security.pki.certificateFiles = [
    ../assets/mitmproxy-ca-cert-gl503ge.pem
  ];

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
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  services.sunshine = {
    enable = false;
    openFirewall = true;
    capSysAdmin = true;
  };
}
