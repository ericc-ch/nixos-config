{
  imports = [
    ./shared.nix
    ../hardware/gl503ge.nix
  ];

  networking.hostName = "gl503ge";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
