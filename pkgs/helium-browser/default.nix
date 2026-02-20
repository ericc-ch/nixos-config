{
  lib,
  pkgs,
  ...
}:
let
  metadata = builtins.fromJSON (builtins.readFile ./metadata.json);
in
pkgs.appimageTools.wrapType2 rec {
  pname = "helium";
  inherit (metadata) version;

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${metadata.version}/helium-${metadata.version}-x86_64.AppImage";
    inherit (metadata) hash;
  };

  extraInstallCommands =
    let
      contents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/helium"
      cp -r ${contents}/opt/helium/locales "$out/share/lib/helium"
      cp -r ${contents}/usr/share/* "$out/share"
      cp "${contents}/${pname}.desktop" "$out/share/applications/"
    '';

  meta = {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://github.com/imputnet/helium-chromium";
    changelog = "https://github.com/imputnet/helium-linux/releases/tag/${version}";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3;
    mainProgram = "helium";
  };
}
