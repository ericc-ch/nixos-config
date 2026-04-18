{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];

  # Load lz4 early in initrd (before zswap tries to use it)
  # See: https://discourse.nixos.org/t/lz4-zswap-compression-type-not-loaded-at-boot/64684
  boot.initrd.systemd.enable = true; # Required for lz4 compressor
  boot.initrd.kernelModules = [ "lz4" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/236488eb-ca2b-414d-b2c2-6fa7a8163644";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C2F7-C926";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/78dde33c-e1ca-4d1d-bf65-3ceb0d3d99d4"; }
  ];

  # See: https://wiki.nixos.org/wiki/Swap#Zswap_swap_cache
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4" # Low CPU overhead (fastest)
    "zswap.max_pool_percent=15" # ~1.6GB max for 11GB RAM
    "zswap.zpool=zsmalloc" # Dense memory packing
    "zswap.shrinker_enabled=1" # Proactively evict cold pages to disk
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
