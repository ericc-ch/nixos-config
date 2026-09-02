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
  pname = "zcode";
  inherit (metadata) version;

  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  appDir = "opt/ZCode";
  executable = "zcode";
  desktopFile = "zcode.desktop";
  desktopExec = "/opt/ZCode/zcode";
  iconPaths = [ "usr/share/icons/hicolor" ];

  meta = {
    description = "ZCode desktop app — official harness for GLM, vibe coding with multiple agents";
    homepage = "https://zcode.z.ai";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "zcode";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
