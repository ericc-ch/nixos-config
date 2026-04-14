{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [
    nvtopPackages.intel
    (writeShellScriptBin "davinci-resolve" ''
      unset QT_QPA_PLATFORMTHEME
      exec ${pkgs.davinci-resolve}/bin/davinci-resolve "$@"
    '')
  ];

  programs.git.signing = {
    key = "~/.ssh/id_ed25519";
    signByDefault = true;
  };
}
