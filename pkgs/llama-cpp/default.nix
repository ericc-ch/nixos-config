{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
  vulkan-loader,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
  srcDir = "llama-${metadata.version}";
in
stdenv.mkDerivation {
  pname = "llama-cpp";
  inherit (metadata) version;

  src = fetchurl {
    url = "https://github.com/ggml-org/llama.cpp/releases/download/${metadata.version}/llama-${metadata.version}-bin-ubuntu-vulkan-x64.tar.gz";
    inherit (metadata) hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    openssl
    vulkan-loader
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

    mkdir -p $out/bin $out/share/doc/llama-cpp
    cp -a ${srcDir}/* $out/bin/
    chmod -R u+w $out/bin
    mv $out/bin/LICENSE $out/share/doc/llama-cpp/

    runHook postInstall
  '';

  meta = {
    description = "Prebuilt llama.cpp Vulkan binaries from GitHub releases";
    homepage = "https://github.com/ggml-org/llama.cpp";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "llama-server";
  };
}
