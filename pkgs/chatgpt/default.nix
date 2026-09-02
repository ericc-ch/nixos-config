{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  writeShellApplication,
  util-linux,
  xdg-utils,
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
  libglvnd,
  mesa,
  nspr,
  nss,
  pango,
  udev,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
  launcher = writeShellApplication {
    name = "chatgpt-launcher";
    runtimeInputs = [ util-linux ];

    text = ''
      : "''${CHATGPT_EXECUTABLE:?}"
      : "''${CHATGPT_RESOURCES_SOURCE:?}"
      : "''${CHATGPT_RESOURCES_CACHE_LABEL:?}"

      cacheHome="''${XDG_CACHE_HOME:-''${HOME:?XDG_CACHE_HOME and HOME are unset}/.cache}"
      cacheRoot="$cacheHome/chatgpt/bundled-plugins"
      resourcesSourceHash=$(printf '%s' "$CHATGPT_RESOURCES_SOURCE" | sha256sum)
      resourcesSourceHash="''${resourcesSourceHash%% *}"
      cacheKey="$CHATGPT_RESOURCES_CACHE_LABEL-$resourcesSourceHash"
      resourcesPath="$cacheRoot/$cacheKey"

      mkdir -p "$cacheRoot"
      exec {resourcesLockFd}> "$cacheRoot/$cacheKey.lock"
      flock --exclusive "$resourcesLockFd"

      if [[ ! -f "$resourcesPath/.complete" ]]; then
        stagingPath=$(mktemp -d "$cacheRoot/.staging-$cacheKey.XXXXXXXX")
        trap 'rm -rf -- "$stagingPath"' EXIT

        requiredResourcePaths=()
        for requiredResourceName in codex codex-code-mode-host cua_node native rg; do
          requiredResourcePath="$CHATGPT_RESOURCES_SOURCE/$requiredResourceName"
          if [[ ! -e "$requiredResourcePath" ]]; then
            echo "Missing ChatGPT resource: $requiredResourcePath" >&2
            exit 1
          fi
          requiredResourcePaths+=("$requiredResourcePath")
        done

        ln -s "''${requiredResourcePaths[@]}" "$stagingPath"
        cp -R "$CHATGPT_RESOURCES_SOURCE/plugins" "$stagingPath/plugins"
        chmod -R u+w "$stagingPath/plugins"
        touch "$stagingPath/.complete"
        mv "$stagingPath" "$resourcesPath"
        trap - EXIT
      fi

      exec {resourcesLockFd}>&-
      export CODEX_ELECTRON_BUNDLED_PLUGINS_RESOURCES_PATH="$resourcesPath"

      configHome="''${XDG_CONFIG_HOME:-''${HOME:?XDG_CONFIG_HOME and HOME are unset}/.config}"
      heliumDataDir="$configHome/net.imput.helium"
      if [[ -d "$heliumDataDir" ]]; then
        export CODEX_CHROMIUM_USER_DATA_DIR="''${CODEX_CHROMIUM_USER_DATA_DIR:-$heliumDataDir}"
        export CODEX_CHROMIUM_NATIVE_HOST_MANIFEST_PATH="''${CODEX_CHROMIUM_NATIVE_HOST_MANIFEST_PATH:-$heliumDataDir/NativeMessagingHosts/com.openai.codexextension.json}"
      fi

      waylandFlags=()
      if [[ -n "''${NIXOS_OZONE_WL:-}" && -n "''${WAYLAND_DISPLAY:-}" ]]; then
        waylandFlags=(
          --ozone-platform-hint=auto
          --enable-features=WaylandWindowDecorations
        )
      fi

      exec "$CHATGPT_EXECUTABLE" "''${waylandFlags[@]}" "$@"
    '';
  };
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

  postPatch = ''
    grep -aFq 'const family = familySync();' usr/lib/chatgpt/resources/app.asar
    asarSize=$(stat -c %s usr/lib/chatgpt/resources/app.asar)
    sed -i "s|const family = familySync();|const family = 'glibc' ;    |" usr/lib/chatgpt/resources/app.asar
    test "$(stat -c %s usr/lib/chatgpt/resources/app.asar)" -eq "$asarSize"
  '';

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

  runtimeDependencies = [ libglvnd ];

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

    substituteInPlace $out/lib/chatgpt/resources/plugins/openai-bundled/plugins/chrome/scripts/installManifest.mjs \
      --replace-fail '".config/google-chrome-for-testing/NativeMessagingHosts"]' '".config/google-chrome-for-testing/NativeMessagingHosts",".config/net.imput.helium/NativeMessagingHosts"]'

    substituteInPlace $out/lib/chatgpt/resources/plugins/openai-bundled/plugins/chrome/scripts/extension-ids.json \
      --replace-fail '          "google-chrome-for-testing"' $'          "google-chrome-for-testing",\n          "helium"' \
      --replace-fail '          ".config/google-chrome-for-testing/NativeMessagingHosts"' $'          ".config/google-chrome-for-testing/NativeMessagingHosts",\n          ".config/net.imput.helium/NativeMessagingHosts"' \
      --replace-fail $'        "processNames": [\n          "chrome"\n        ],' $'        "processNames": [\n          "chrome",\n          "helium"\n        ],'

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
    makeWrapper ${launcher}/bin/chatgpt-launcher $out/bin/chatgpt \
      --set CHATGPT_EXECUTABLE $out/lib/chatgpt/ChatGPT \
      --set CHATGPT_RESOURCES_SOURCE $out/lib/chatgpt/resources \
      --set CHATGPT_RESOURCES_CACHE_LABEL ${version} \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
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
