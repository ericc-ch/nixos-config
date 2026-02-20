{
  lib,
  pkgs,
  ...
}:
let
  hashes = builtins.fromJSON (builtins.readFile ./metadata.json);
in
pkgs.appimageTools.wrapType2 rec {
  pname = "helium";
  inherit (hashes) version;

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${hashes.version}/helium-${hashes.version}-x86_64.AppImage";
    inherit (hashes) hash;
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
      substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
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
