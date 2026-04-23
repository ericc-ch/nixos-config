{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [ shotcut ];
}
