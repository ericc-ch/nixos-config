{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [
    moonlight-qt
    shotcut
  ];
}
