{
  coreutils,
  findutils,
  lib,
  writeShellScriptBin,
}:

# Launcher that execs the latest t3 runtime downloaded into ~/.t3/runtime/versions.
writeShellScriptBin "t3" ''
  set -eu
  versions_dir="''${T3CODE_HOME:-$HOME/.t3}/runtime/versions"
  latest="$(${findutils}/bin/find "$versions_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | ${coreutils}/bin/sort -V | ${coreutils}/bin/tail -n1)"
  if [ -z "$latest" ]; then
    echo "error: no t3 runtime found in $versions_dir" >&2
    exit 1
  fi
  exec "$versions_dir/$latest/t3" "$@"
''
// {
  meta = with lib; {
    description = "Launcher for the latest locally installed T3 Code runtime";
    platforms = [ "x86_64-linux" ];
    mainProgram = "t3";
  };
}
