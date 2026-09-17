{
  callPackage,
  fetchurl,
  lib,
  perl,
}:

let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
  mkElectronDebApp = callPackage ../lib/mk-electron-deb-app.nix { };

  # The desktop injects the service's `Authorization: Basic opencode:<password>`
  # header at the Electron network layer, but the request filter is hardcoded
  # to loopback URLs (`http://127.0.0.1/*`, `http://localhost/*`). A service
  # bound to a non-loopback address (e.g. a Tailscale IP) therefore receives
  # no credentials and the UI retry-loops on 401. Broaden the filter to every
  # URL; the same handler still requires the request origin to match the
  # configured service before injecting the header. The replacement keeps the
  # byte length identical so the app.asar header's file offsets stay valid.
  authFilterOld = "urls:[`http://127.0.0.1/*`,`http://localhost/*`]";
  authFilterNew =
    let
      allUrls = "`<all_urls>`";
      base = "urls:[${allUrls},${allUrls}]";
      pad = lib.stringLength authFilterOld - lib.stringLength base;
    in
    "urls:[${allUrls}${lib.strings.replicate pad " "},${allUrls}]";
in
mkElectronDebApp {
  pname = "opencode-desktop";
  inherit (metadata) version;

  src = fetchurl {
    inherit (metadata) url;
    inherit (metadata) hash;
  };

  appDir = "opt/OpenCode";
  executable = "ai.opencode.desktop";
  desktopFile = "ai.opencode.desktop.desktop";
  desktopExec = "/opt/OpenCode/ai.opencode.desktop";
  iconPaths = [ "usr/share/icons/hicolor" ];

  # The bundled v2 CLI is a Bun standalone executable whose appended payload
  # patchelf/strip corrupt (it degrades to the plain Bun runtime).
  autoPatchelfExclude = [ "lib/opencode-desktop/resources/opencode-cli" ];

  postInstall = ''
    asar="$out/lib/opencode-desktop/resources/app.asar"
    before=$(stat -c%s "$asar")
    OLD=${lib.escapeShellArg authFilterOld} NEW=${lib.escapeShellArg authFilterNew} \
      ${perl}/bin/perl -0777 -i -pe \
        's/\Q$ENV{OLD}\E/$ENV{NEW}/g or die "opencode-desktop: service auth filter not found in app.asar\n"' \
        "$asar"
    after=$(stat -c%s "$asar")
    if [ "$before" != "$after" ]; then
      echo "opencode-desktop: patching app.asar changed its size" >&2
      exit 1
    fi
  '';

  meta = {
    description = "OpenCode desktop app (V2) — open source AI coding agent";
    homepage = "https://opencode.ai/download";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    mainProgram = "opencode-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
