{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libappindicator-gtk3,
  libdrm,
  libnotify,
  libsecret,
  libusb1,
  libuuid,
  libxkbcommon,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxscrnsaver,
  libxtst,
  mesa,
  nspr,
  nss,
  pango,
  udev,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
in
stdenv.mkDerivation rec {
  pname = "chatgpt";
  inherit (metadata) version;

  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  # Bundled node modules ship musl prebuilds (*musl*.node) next to the glibc
  # ones; they never load on glibc, so ignore their interpreter instead of
  # providing musl.
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  # Electron runtime deps (from the deb's Depends + `ldd` of the main binary).
  buildInputs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libappindicator-gtk3
    libdrm
    libnotify
    libsecret
    libusb1
    libuuid
    libxkbcommon
    mesa
    nspr
    nss
    pango
    udev
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxscrnsaver
    libxtst
  ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p src-unpacked
    dpkg-deb -x $src src-unpacked
    sourceRoot=src-unpacked
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/chatgpt
    cp -r usr/lib/chatgpt/. $out/lib/chatgpt/

    # The deb's Qt theme-integration shims hard-link libQt5/libQt6; the app
    # only dlopens them under a Qt desktop, and pulling both toolkits into
    # the closure is not worth it — drop them so it falls back to GTK.
    rm $out/lib/chatgpt/libqt5_shim.so $out/lib/chatgpt/libqt6_shim.so

    substituteInPlace usr/share/applications/chatgpt.desktop \
      --replace-fail 'Exec=chatgpt %U' "Exec=$out/bin/chatgpt %U"
    mkdir -p $out/share/applications
    cp usr/share/applications/chatgpt.desktop $out/share/applications/

    mkdir -p $out/share/pixmaps
    cp usr/share/pixmaps/chatgpt.png $out/share/pixmaps/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/chatgpt/ChatGPT $out/bin/chatgpt \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}"
  '';

  meta = {
    description = "ChatGPT desktop app — OpenAI assistant with Codex, Work, and Deep Research";
    homepage = "https://chatgpt.com/download/";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
