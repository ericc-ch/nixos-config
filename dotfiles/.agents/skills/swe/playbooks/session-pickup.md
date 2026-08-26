# Session pickup

**You own the resume point. Read the prior trail; do not redo it.** For "take over this", "continue where X left off", resuming from a handoff doc, or landing on a pushed branch meant to be continued.

A pickup is inheritance. The prior agent already paid for reading the code, running the repros, making the calls. Redoing loses that context and burns your window. Resist the urge to re-derive; read.

1. Locate the prior trail: a handoff doc (`/tmp/handoff-*.md`, or `wiki/work/*/handoff.md` for tracked work), `wiki/work/*/` specs, tickets, and maps, plan notes, or the pushed branch itself. Read the summary first, then scan back for decision points. Long transcripts get parsed in a readonly subagent; keep the reduced timeline in the main thread.
2. Reconstruct operational state: current branch and worktree, what landed (`git log`, `git diff` against base), open tickets and unchecked acceptance boxes, decisions made. The trail is authoritative input.
3. Diff done versus pending. Name the resume point explicitly. Do not re-run completed repros or redo shipped work; "let me verify everything from scratch" is the failure tell.
4. Route remaining work to the matching playbook (bug-fix, feature, refactoring...). This playbook ends there; the routed playbook owns the rest.
5. Verify inherited claims against the original goal on the real artifact. A passing prior self-report is not proof.

**Reply:** where the prior agent stopped, what you inherited versus redone (ideally nothing redone), the resume point, outcome.
