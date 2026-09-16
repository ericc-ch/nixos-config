# Vendored from nix-community/browser-previews google-chrome/default.nix
# (based on NixOS/nixpkgs google-chrome). Dev channel only. See README.md.
{
  fetchurl,
  lib,
  stdenv,
  bintools,
  patchelf,
  makeWrapper,

  glib,
  fontconfig,
  freetype,
  pango,
  cairo,
  libx11,
  libxi,
  atk,
  nss,
  nspr,
  libxcursor,
  libxext,
  libxfixes,
  libxrender,
  libxscrnsaver,
  libxcomposite,
  libxcb,
  alsa-lib,
  libxdamage,
  libxtst,
  libxrandr,
  libxshmfence,
  expat,
  cups,
  dbus,
  gtk3,
  gtk4,
  gdk-pixbuf,
  gcc-unwrapped,
  at-spi2-atk,
  at-spi2-core,
  libkrb5,
  libdrm,
  libglvnd,
  libgbm,
  libxkbcommon,
  pipewire,
  wayland,
  vulkan-loader,

  coreutils,

  commandLineArgs ? "",

  systemd,

  libexif,
  pciutils,

  liberation_ttf,
  curl,
  util-linux,
  xdg-utils,
  wget,
  flac,
  harfbuzz,
  icu,
  libpng,
  libopus,
  snappy,
  speechd-minimal,
  bzip2,
  libcap,

  pulseSupport ? true,
  libpulseaudio,

  gsettings-desktop-schemas,
  adwaita-icon-theme,

  libvaSupport ? true,
  libva,

  addDriverRunpath,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);

  opusWithCustomModes = libopus.override { withCustomModes = true; };

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    bzip2
    cairo
    coreutils
    cups
    curl
    dbus
    expat
    flac
    fontconfig
    freetype
    gcc-unwrapped.lib
    gdk-pixbuf
    glib
    harfbuzz
    icu
    libcap
    libdrm
    liberation_ttf
    libexif
    libglvnd
    libkrb5
    libpng
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    libgbm
    nspr
    nss
    opusWithCustomModes
    pango
    pciutils
    pipewire
    snappy
    speechd-minimal
    systemd
    util-linux
    vulkan-loader
    wayland
    wget
  ]
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional libvaSupport libva
  ++ [
    gtk3
    gtk4
  ];
in
stdenv.mkDerivation {
  pname = "google-chrome-dev";
  inherit (metadata) version;

  src = fetchurl {
    inherit (metadata) url hash;
  };

  nativeBuildInputs = [
    bintools
    patchelf
    makeWrapper
  ];

  buildInputs = [
    gsettings-desktop-schemas
    glib
    gtk3
    gtk4
    adwaita-icon-theme
  ];

  unpackPhase = ''
    runHook preUnpack
    ${lib.getExe' bintools "ar"} x $src
    tar xf data.tar.xz
    runHook postUnpack
  '';

  rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;
  binpath = lib.makeBinPath deps;

  installPhase = ''
    runHook preInstall

    appname=chrome-unstable
    dist=unstable
    exe=$out/bin/google-chrome-$dist

    mkdir -p $out/bin $out/share
    cp -a opt/* $out/share
    cp -a usr/share/* $out/share

    rm -f $out/share/google/$appname/libvulkan.so.1
    ln -s -t "$out/share/google/$appname" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

    substituteInPlace $out/share/google/$appname/google-$appname \
      --replace-fail 'CHROME_WRAPPER' 'WRAPPER'

    for desktop in $out/share/applications/*.desktop; do
      substituteInPlace "$desktop" --replace-quiet /usr/bin/google-chrome-$dist $exe
    done

    if [[ -f $out/share/gnome-control-center/default-apps/google-$appname.xml ]]; then
      substituteInPlace $out/share/gnome-control-center/default-apps/google-$appname.xml \
        --replace-fail /opt/google/$appname/google-$appname $exe
    fi

    if [[ -f $out/share/menu/google-$appname.menu ]]; then
      substituteInPlace $out/share/menu/google-$appname.menu \
        --replace-fail /opt $out/share \
        --replace-fail $out/share/google/$appname/google-$appname $exe
    fi

    for icon_file in $out/share/google/chrome*/product_logo_[0-9]*.png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%_*}"
      logo_output_path="$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps"
      mkdir -p "$logo_output_path"
      mv "$icon_file" "$logo_output_path/google-$appname.png"
    done

    makeWrapper "$out/share/google/$appname/google-$appname" "$exe" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH : "$binpath" \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
      --set CHROME_WRAPPER "google-chrome-$dist" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    ln -s $exe $out/bin/google-chrome-dev

    for elf in $out/share/google/$appname/{chrome,chrome-sandbox,chrome_crashpad_handler}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done

    runHook postInstall
  '';

  meta = {
    description = "Freeware web browser developed by Google (Dev channel)";
    homepage = "https://www.google.com/chrome/dev/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "google-chrome-dev";
  };
}
