{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);

  platforms = {
    x86_64-linux = {
      npmPlatform = "linux-x64-gnu";
      system = "linux-x64";
    };
    aarch64-linux = {
      npmPlatform = "linux-arm64-gnu";
      system = "linux-arm64";
    };
    x86_64-darwin = {
      npmPlatform = "darwin-x64";
      system = "darwin-x64";
    };
    aarch64-darwin = {
      npmPlatform = "darwin-arm64";
      system = "darwin-arm64";
    };
  };

  platformInfo =
    platforms.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
  npmPlatform = platformInfo.npmPlatform;
  platformMeta = metadata.platforms.${npmPlatform};
in
stdenv.mkDerivation {
  pname = "vp";
  inherit (metadata) version;

  src = fetchurl {
    inherit (platformMeta) url hash;
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
    tar -xzf $src --strip-components=1
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 vp $out/bin/vp

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Unified toolchain for the web (Vite+)";
    homepage = "https://vite.plus";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames platforms;
    mainProgram = "vp";
  };
}
