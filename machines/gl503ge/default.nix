{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "gl503ge";

  security.pki.certificateFiles = [
    ./mitmproxy-ca-cert.pem
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      intel-compute-runtime.drivers
      # PyTorch XPU / Level Zero need the loader + IGC at runtime
      level-zero
      intel-graphics-compiler
      vpl-gpu-rt
    ];
  };

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    # List form: NixOS joins with ":" (see environment.sessionVariables docs).
    # Same pattern the old hardware.opengl.setLdLibraryPath option used.
    LD_LIBRARY_PATH = [ "/run/opengl-driver/lib" ];
  };

  fileSystems."/mnt/ssd".options = [
    "nofail"
    "noatime"
  ];
  fileSystems."/mnt/hdd".options = [
    "nofail"
    "noatime"
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

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

  home-manager.users.erickc = {
    imports = [ ../../home/shared.nix ];
    home.packages = with pkgs; [ ];
  };
}
