{
  deno,
  lib,
  writeShellScriptBin,
}:

# Local OpenAI-compat proxy for Handy → Google Gemini API.
#
# Handy Custom always sends reasoning_effort: "none", which Google's OpenAI
# layer maps to thinking_budget and Gemma rejects. This proxy strips / remaps
# reasoning fields for Gemma, then forwards.
#
# Point Handy Custom base URL at:
#   http://127.0.0.1:8787/v1beta/openai
let
  src = ./handy-proxy.ts;
in
writeShellScriptBin "handy-proxy" ''
  exec ${deno}/bin/deno run -A ${src} "$@"
''
// {
  meta = with lib; {
    description = "OpenAI-compat proxy for Handy → Google Gemini, fixing Gemma thinking budget";
    platforms = [ "x86_64-linux" ];
    mainProgram = "handy-proxy";
  };
}
