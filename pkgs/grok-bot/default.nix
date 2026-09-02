{
  callPackage,
  fetchurl,
  lib,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
  mkElectronDebApp = callPackage ../lib/mk-electron-deb-app.nix { };
in
mkElectronDebApp {
  pname = "grok-bot";
  inherit (metadata) version;

  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  appDir = "opt/Grok Bot";
  executable = "grok-bot";
  desktopFile = "grok-bot.desktop";
  desktopExec = "grok-bot";
  iconPaths = [ "usr/share/icons/hicolor" ];

  meta = {
    description = "Grok Bot desktop agent — AI teammates that work inside your tools";
    homepage = "https://x.ai/bot";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "grok-bot";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
