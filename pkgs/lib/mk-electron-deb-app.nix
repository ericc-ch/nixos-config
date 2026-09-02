# Packaging policy for third-party Electron apps shipped as .deb: unpack the
# deb, autoPatch against the union Electron runtime dependency set, install
# the app tree plus desktop entry and icons, and wrap the Electron binary
# with the NixOS Wayland (Ozone) flags and xdg-utils.
#
# The wrapper produced here covers the common case of exec'ing the Electron
# binary directly. Apps with their own launch policy (staged caches, env
# indirection) override postFixup with their own makeWrapper.
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  xdg-utils,
  libglvnd,
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

{
  pname,
  # version/url/hash of the .deb, normally inherit-ed from metadata.json.
  version,
  src,
  # App tree inside the unpacked deb, e.g. "opt/ZCode" or "usr/lib/chatgpt".
  appDir,
  # Electron binary inside appDir to wrap, e.g. "zcode" or "ChatGPT".
  executable,
  # Basename of the desktop file in the deb's usr/share/applications.
  desktopFile,
  # The Exec value in the shipped desktop file; rewritten to $out/bin/${pname}.
  desktopExec,
  # Paths under the deb's usr/share to install verbatim; the destination
  # mirrors the usr/share layout.
  iconPaths,
  # Base names of ELF deps shipped in the deb that never resolve on glibc
  # (e.g. musl prebuilds) and should not fail the patch.
  autoPatchelfIgnoreMissingDeps ? [ ],
  postPatch ? "",
  postInstall ? "",
  # Replaces the standard wrapper entirely; for wrapping a custom launcher.
  postFixup ? null,
  meta,
}@args:

let
  installIconCommands = lib.concatMapStringsSep "\n" (
    path:
    let
      rel = lib.removePrefix "usr/share/" path;
    in
    ''
      mkdir -p $out/share/${dirOf rel}
      cp -r ${path} $out/share/${rel}
    ''
  ) iconPaths;

  standardPostFixup = ''
    makeWrapper $out/lib/${pname}/${executable} $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}" \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  # Electron runtime deps (union of the debs' Depends + `ldd` of the main
  # binaries). libglvnd is not a linked dep: the bundled ANGLE dlopens
  # libGL.so.1 at runtime, so it only reaches the RPATH via
  # runtimeDependencies.
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

  runtimeDependencies = [ libglvnd ];

  inherit autoPatchelfIgnoreMissingDeps postPatch;

  unpackPhase = ''
    runHook preUnpack
    mkdir -p src-unpacked
    dpkg-deb -x $src src-unpacked
    sourceRoot=src-unpacked
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${pname}
    cp -r "${appDir}"/. $out/lib/${pname}/

    substituteInPlace usr/share/applications/${desktopFile} \
      --replace-fail 'Exec=${desktopExec}' "Exec=$out/bin/${pname}"
    mkdir -p $out/share/applications
    cp usr/share/applications/${desktopFile} $out/share/applications/

    ${installIconCommands}

    ${postInstall}

    runHook postInstall
  '';

  postFixup = if postFixup != null then postFixup else standardPostFixup;

  inherit meta;
}
