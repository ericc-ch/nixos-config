- User is experienced with TypeScript.
- Keep explanation simple, minimize jargons.

- Read and write to file with the proper built in tools (`read`/`write`/`edit`/`patch`). Never do it through `shell`.
- Use `grep` and `glob` to find things.
- Pass `workdir` instead of prefixing `cd ... &&`.
- Keep one purpose per call, and do not pipe a command through `head`/`tail` when the exit status is the answer.
- An exit 1 from a check or search is not automatically a failure. Explain it instead of rerunning the same probe.

## Environment

- This host runs NixOS. There is no system `python3`, use `uv`.
- Use the project dev shell (`nix develop`) or `mise`/`uv` toolchains if available.
- Use `/tmp` for throwaway work.
