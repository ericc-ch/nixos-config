{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "hp240g5";

  security.pki.certificateFiles = [
    ./mitmproxy-ca-cert.pem
  ];

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    # intel-media-sdk
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "intel-media-sdk-23.2.2"
  ];

  fileSystems."/mnt/hdd".options = [
    "defaults"
    "noatime"
    "nofail"
  ];

  services.power-profiles-daemon.enable = true;

  # Load lz4 early in initrd (before zswap tries to use it)
  # See: https://discourse.nixos.org/t/lz4-zswap-compression-type-not-loaded-at-boot/64684
  boot.initrd.systemd.enable = true; # Required for lz4 compressor
  boot.initrd.kernelModules = [ "lz4" ];

  # See: https://wiki.nixos.org/wiki/Swap#Zswap_swap_cache
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4" # Low CPU overhead (fastest)
    "zswap.max_pool_percent=15" # ~1.6GB max for 11GB RAM
    "zswap.zpool=zsmalloc" # Dense memory packing
    "zswap.shrinker_enabled=1" # Proactively evict cold pages to disk
  ];

  home-manager.users.erickc = {
    imports = [ ../../home/shared.nix ];
    home.packages = with pkgs; [
      # moonlight-qt
    ];
  };
}
