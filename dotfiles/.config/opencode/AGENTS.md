# Global rules

The user knows TypeScript well. Explain in plain words and skip jargon.

A project `AGENTS.md` takes priority when one exists.

## Tools

- Read and write files with `read`, `write`, `edit`, and `patch`. Do not edit files through the shell.
- Find files with `glob`. Search inside them with `grep`.
- Pass `workdir` instead of `cd ... &&`.
- Do one thing per call. If the exit status answers the question, do not pipe through `head` or `tail`.
- An exit 1 from a check or search is not always a failure. Explain what it means instead of running the same command again.
- Run the repo's own check before saying the work is done.

## Code

- Simplicity is not brevity. A naive short version that skips edge cases is simplistic, not simple. Write the obvious version, even when it takes more lines.
- More code is fine when it makes the behavior easier to follow. Do not skip an edge case to keep the change small.
- Use the `code-conventions` skill for the detailed rules.

## Environment

- This machine runs NixOS. There is no `python3`, so use `uv`.
- Use `nix develop`, `mise`, or `uv` when the project has them.
- Use `/tmp/opencode` for temporary files.
