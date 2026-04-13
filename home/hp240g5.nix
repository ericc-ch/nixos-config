{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [
    nvtopPackages.intel
    shotcut
  ];

  programs.git.signing = {
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC28psBMHG/XaZtUPaVJHDRvS/Rht0BTEwxTnxDadQoB erickc@hp240g5";
    signByDefault = true;
  };
}
