{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [
    nvtopPackages.intel
    shotcut
  ];

  programs.git.signing = {
    key = "~/.ssh/id_ed25519.pub";
    signByDefault = true;
  };
}
