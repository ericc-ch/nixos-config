{
  lib,
  stdenv,
  fetchurl,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
  # Asset names follow the setup script's platform detection:
  # <os>-<arch> with x86_64/aarch64 (not amd64).
  platform =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then "linux-x86_64"
    else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 then "linux-aarch64"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then "macos-x86_64"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then "macos-aarch64"
    else throw "fx: unsupported platform ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "fx";
  inherit (metadata) version;

  src = fetchurl {
    url = "https://github.com/vercel-labs/fx/releases/download/${metadata.version}/fx-${platform}.tar.gz";
    inherit (metadata) hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    tar -xzf "$src"
    install -Dm755 fx "$out/bin/fx"
    install -Dm644 LICENSE "$out/share/doc/fx/LICENSE"
    install -Dm644 THIRD_PARTY_NOTICES.md "$out/share/doc/fx/THIRD_PARTY_NOTICES.md"
    runHook postInstall
  '';

  meta = {
    description = "Tiny, open, embeddable, native coding agent CLI written in Zig";
    homepage = "https://fx.sh";
    changelog = "https://github.com/vercel-labs/fx/releases/tag/${metadata.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "fx";
  };
}
