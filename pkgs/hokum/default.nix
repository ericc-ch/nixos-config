{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  libxkbcommon,
  pipewire,
  vulkan-loader,
  wayland,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);

  # The binary links only libxkbcommon; Wayland, Vulkan and PipeWire are
  # dlopened at run time, so they need to be on the loader path.
  runtimeLibs = [
    libxkbcommon
    pipewire
    vulkan-loader
    wayland
  ];
in
stdenv.mkDerivation {
  pname = "hokum";
  inherit (metadata) version;

  # The signed release .deb, not a source build: compiling Hokum builds Rune
  # and the PipeWire/BlueZ bindings. `./update.sh` bumps this from the dev
  # channel's release manifest (stable has no Sound/Bluetooth modules yet).
  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = runtimeLibs ++ [ stdenv.cc.cc.lib ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --extract $src .
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 usr/bin/hokum $out/bin/hokum

    install -Dm644 usr/share/applications/hokum.desktop \
      $out/share/applications/hokum.desktop
    substituteInPlace $out/share/applications/hokum.desktop \
      --replace-fail 'Exec=hokum' "Exec=$out/bin/hokum"

    # The session bus finds this file through XDG_DATA_HOME (installed by
    # home/shared.nix) and activates hokum.service by name.
    install -Dm644 usr/share/dbus-1/services/app.hokum.Notifications.service \
      $out/share/dbus-1/services/app.hokum.Notifications.service
    substituteInPlace $out/share/dbus-1/services/app.hokum.Notifications.service \
      --replace-fail /usr/bin/hokum "$out/bin/hokum"

    install -Dm644 usr/share/licenses/hokum/LICENSE \
      $out/share/licenses/hokum/LICENSE

    runHook postInstall
  '';

  # Rune looks for fallback fonts (emoji) in $XDG_DATA_DIRS/*/fonts; NixOS
  # keeps them in X11/fonts.
  postFixup = ''
    wrapProgram $out/bin/hokum \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --suffix XDG_DATA_DIRS : /run/current-system/sw/share/X11
  '';

  meta = {
    description = "Wayland control center: notifications, sound and Bluetooth";
    homepage = "https://hokum.app";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "hokum";
  };
}
