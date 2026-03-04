{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [
    nvtopPackages.intel
    shotcut
  ];
}
