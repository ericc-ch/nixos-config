{ pkgs, ... }:

{
  imports = [ ./shared.nix ];

  home.packages = with pkgs; [
    (writeShellScriptBin "davinci-resolve" ''
      unset QT_QPA_PLATFORMTHEME
      exec ${pkgs.davinci-resolve}/bin/davinci-resolve "$@"
    '')
  ];
}
