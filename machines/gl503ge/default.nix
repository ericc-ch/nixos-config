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

  # zswap needs a real swap device for slots and cold-page writeback.
  # Keep this in default.nix, not hardware.nix (regenerable).
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # MiB
    }
  ];

  # Load lz4 early in initrd (before zswap tries to use it)
  # See: https://discourse.nixos.org/t/lz4-zswap-compression-type-not-loaded-at-boot/64684
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "lz4" ];

  # See: https://wiki.nixos.org/wiki/Swap#Zswap_swap_cache
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4"
    "zswap.max_pool_percent=25" # ~8GB max for 32GB RAM
    "zswap.shrinker_enabled=1"
  ];

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
