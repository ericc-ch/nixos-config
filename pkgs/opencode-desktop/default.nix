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
  pname = "opencode-desktop";
  inherit (metadata) version;

  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  appDir = "opt/OpenCode Beta";
  executable = "ai.opencode.desktop.beta";
  desktopFile = "ai.opencode.desktop.beta.desktop";
  desktopExec = ''"/opt/OpenCode Beta/ai.opencode.desktop.beta"'';
  iconPaths = [ "usr/share/icons/hicolor" ];

  # The bundled v2 CLI is a Bun standalone executable whose appended payload
  # patchelf/strip corrupt (it degrades to the plain Bun runtime).
  autoPatchelfExclude = [ "lib/opencode-desktop/resources/opencode-cli" ];

  meta = {
    description = "OpenCode desktop app (V2 beta) — open source AI coding agent";
    homepage = "https://opencode.ai/download";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    mainProgram = "opencode-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
