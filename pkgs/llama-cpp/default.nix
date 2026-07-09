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

    # Keep .so backends next to the binaries (llama.cpp loads them from
    # the executable directory) but out of $out/bin so Home Manager does
    # not publish them into the profile PATH. GLib GIO scans every .so in
    # profile bin/ as a GIO module and spams "undefined symbol: g_io_module_load".
    mkdir -p $out/bin $out/libexec/llama-cpp $out/share/doc/llama-cpp
    cp -a ${srcDir}/* $out/libexec/llama-cpp/
    chmod -R u+w $out/libexec/llama-cpp
    mv $out/libexec/llama-cpp/LICENSE $out/share/doc/llama-cpp/

    for f in $out/libexec/llama-cpp/*; do
      name=$(basename "$f")
      case "$name" in
        *.so|*.so.*) continue ;;
      esac
      [ -f "$f" ] && [ -x "$f" ] || continue
      ln -s ../libexec/llama-cpp/"$name" "$out/bin/$name"
    done

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
