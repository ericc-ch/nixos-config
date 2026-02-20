{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  fzf,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  hashes = builtins.fromJSON (builtins.readFile ./metadata.json);
in
stdenv.mkDerivation {
  pname = "opencode";
  inherit (hashes) version;

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${hashes.version}/opencode-linux-x64.tar.gz";
    inherit (hashes) hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    tar -xzf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 opencode $out/bin/opencode

    wrapProgram $out/bin/opencode \
      --prefix PATH : ${
        lib.makeBinPath [
          fzf
          ripgrep
        ]
      }

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "opencode";
  };
}
