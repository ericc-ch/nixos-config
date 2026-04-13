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
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaph5CBdAMreGvhfsFfZpYKj9mpz0TybSgXlh59/zP2 erickc@gl503ge";
    signByDefault = true;
  };
}
