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
  pname = "grok-bot";
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

    mkdir -p $out/lib/grok-bot
    cp -r "opt/Grok Bot"/. $out/lib/grok-bot/

    substituteInPlace usr/share/applications/*.desktop \
      --replace-fail '/opt/Grok Bot/grok-bot' $out/bin/grok-bot
    mkdir -p $out/share/applications
    cp usr/share/applications/*.desktop $out/share/applications/

    mkdir -p $out/share/icons
    cp -r usr/share/icons/hicolor $out/share/icons/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/grok-bot/grok-bot $out/bin/grok-bot \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}"
  '';

  meta = {
    description = "Grok Bot desktop agent — AI teammates that work inside your tools";
    homepage = "https://x.ai/bot";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "grok-bot";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
