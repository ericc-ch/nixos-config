{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  alsa-plugins,
  curl,
  fontconfig,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  openblas,
  openssl,
  pipewire,
  symlinkJoin,
  vulkan-loader,
  wayland,
  wl-clipboard,
  wtype,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);

  # Mirrors the wrapper in Hex's own nix/package.nix. These are loaded at
  # runtime (Vulkan ICD, BLAS, ALSA) rather than recorded as DT_NEEDED, so
  # they have to be on the loader path, not just linked.
  runtimeLibs = [
    vulkan-loader
    openblas
    alsa-lib
    wayland
    libxkbcommon
    fontconfig
    # winit dlopens the X11 stack for the XWayland fallback.
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
  ];

  # Hex records through ALSA's default device. PipeWire and PulseAudio ship
  # their ALSA plugins outside alsa-lib's built-in search path.
  alsaPluginDir = symlinkJoin {
    name = "hex-alsa-plugins";
    paths = [
      "${pipewire}/lib/alsa-lib"
      "${alsa-plugins}/lib/alsa-lib"
    ];
  };
in
stdenv.mkDerivation {
  pname = "hex";
  inherit (metadata) version;

  # The signed release .deb, not a source build: compiling Hex pulls in wgpu,
  # shaderc and the transcribe stack. `./update.sh` bumps this from the
  # release API; the same files are served from
  # https://anoma.ly/hex/download/linux-x64-deb, but that URL always points
  # at the newest release, so this one is versioned.
  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    openssl
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --extract $src .
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 usr/bin/hex $out/bin/hex
    install -Dm644 usr/share/applications/anomaly.hex.desktop \
      $out/share/applications/anomaly.hex.desktop
    substituteInPlace $out/share/applications/anomaly.hex.desktop \
      --replace-fail '/usr/bin/hex' "$out/bin/hex"

    cp -R usr/share/icons $out/share/icons
    install -Dm644 usr/share/licenses/hex/LICENSE $out/share/licenses/hex/LICENSE

    runHook postInstall
  '';

  # The package's own hex.service is deliberately not installed: the Home
  # Manager module owns the user unit and its session environment.
  postFixup = ''
    wrapProgram $out/bin/hex \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          wl-clipboard
          wtype
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --set ALSA_PLUGIN_DIR ${alsaPluginDir}
  '';

  meta = {
    description = "Local-first voice dictation (Linux beta, prebuilt release)";
    homepage = "https://anoma.ly/hex/";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "hex";
  };
}
