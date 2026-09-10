{
  bun,
  lib,
  nix,
  tailscale,
  writeShellScriptBin,
}:

# Bind t3 to this machine's Tailscale IPv4 on port 7373.
writeShellScriptBin "t3code" ''
  TS_IP="$(${tailscale}/bin/tailscale ip -4 2>/dev/null | head -n1 | tr -d '[:space:]')"
  if [ -z "$TS_IP" ]; then
    echo "error: could not get Tailscale IP (is tailscaled up? try 'tailscale status')" >&2
    exit 1
  fi

  echo "Binding t3 to $TS_IP:7373 (tailscale IP: $TS_IP)" >&2
  exec ${nix}/bin/nix shell nixpkgs#python3 nixpkgs#node-gyp --command ${bun}/bin/bunx t3@latest start --host "$TS_IP" --port 7373 "$@"
''
// {
  meta = with lib; {
    description = "Wrapper that binds t3 to the machine's Tailscale IPv4 on port 7373";
    platforms = [ "x86_64-linux" ];
    mainProgram = "t3code";
  };
}
