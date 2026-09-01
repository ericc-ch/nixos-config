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
  pname = "zcode";
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

    mkdir -p $out/lib/zcode
    cp -r opt/ZCode/. $out/lib/zcode/

    substituteInPlace usr/share/applications/*.desktop \
      --replace-fail '/opt/ZCode/zcode' $out/bin/zcode
    mkdir -p $out/share/applications
    cp usr/share/applications/*.desktop $out/share/applications/

    mkdir -p $out/share/icons
    cp -r usr/share/icons/hicolor $out/share/icons/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/zcode/zcode $out/bin/zcode \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}"
  '';

  meta = {
    description = "ZCode desktop app — official harness for GLM, vibe coding with multiple agents";
    homepage = "https://zcode.z.ai";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "zcode";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
