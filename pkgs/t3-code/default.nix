{
  lib,
  pkgs,
  ...
}:
let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
in
pkgs.appimageTools.wrapType2 rec {
  pname = "t3-code";
  inherit (metadata) version;

  src = pkgs.fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${metadata.version}/T3-Code-${metadata.version}-x86_64.AppImage";
    inherit (metadata) hash;
  };

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extract { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      cp -r ${contents}/usr/share/icons "$out/share"
      # Upstream desktop entry execs `AppRun`, which is not on PATH in the
      # wrapped build; point it at the wrapper binary instead.
      sed 's|^Exec=.*|Exec=t3-code --no-sandbox %U|' \
        "${contents}/t3code.desktop" > "$out/share/applications/t3code.desktop"
    '';

  meta = {
    description = "Open-source control plane for coding agents (Claude Code, Codex, OpenCode, Cursor, Grok)";
    homepage = "https://t3.codes/";
    changelog = "https://github.com/pingdotgg/t3code/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "t3-code";
  };
}
