# Opening a PR

Runs at the end of every code playbook.

**Branch.** Work on a branch off the default branch. Dirty tree with unrelated changes: stash or commit them separately first; never mix unrelated work into one diff. Personal repos where committing straight to main is the norm may skip the branch, but all other rules hold.

**Commits.** Commit liberally while working; rebase into small ordered commits before finishing. Each commit is landable alone and tells one piece of the story. Amend when the fix belongs in the just-made commit; new commit when separable. Never `--no-verify` to skip failing hooks without naming why in the reply.

**Pre-flight.**
1. Re-read your own diff as a hostile reviewer (the `review` bar) before anyone else sees it.
2. Run the `simple-english` pass over every user-facing sentence: title, body, commit messages.
3. Run the full check suite: typecheck, tests, lint. Paste real output in the reply, not claims.

**Titles.** Conventional Commits form `type(scope): subject`. Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`. Scope is the changed area. Subject short and imperative, no trailing period. Name the real symbol carrying the change: `fix(navbar): preserve logo aspect ratio`.

**Descriptions.** Sections in this order; drop empty ones. No `## Summary` or `## Test plan` boilerplate.

- `## Why`. The intent and why this approach fits.
- `## Scope`. Facts from the diff. Real symbols and paths; both sides of a rename.
- `## Tradeoffs`. Real choices only; skip when none.
- `## Blast radius`. Who and what it touches; why safe or risky.
- `## Verification`. How each check ran and its outcome, not just the command name.

Screenshots and videos attach when they prove a claim (UI work always).

**After opening.** Post the link, state verification results, stop. Do not start watching CI unprompted; that is a babysit request the human makes explicitly.

A subagent that opens a PR returns the URL and its verification summary; it does not review its own work.
