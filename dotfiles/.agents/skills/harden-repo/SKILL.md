---
name: harden-repo
description: "Fixes repo setup after a hard session. Use when the agent struggled to find files, repeated a mistake a check could catch, or lacked logs or access. Skip personal lessons, use `sharpen-skills`. Skip code verdicts, use `code-review`."
---

Propose fixes to the repo setup after one hard session. Change the setup, not the code. Propose only. Change nothing until the user picks.

## What to fix first

Fix the thing that removes the most future work first:

1. Code: architecture, strict types, invariants, and clear boundaries. Agents copy existing patterns and take the shortest path. Remove ways to fail so the right path is the easiest one. Use the `improve-codebase` skill.
2. Checks: linters, type checks, tests, CI, and formal verification (for example, TLA+). These catch problems early and cost no tokens to run.
3. Words: comments, rules, instruction files (`AGENTS.md`), and skills. Use words only for choices a tool cannot enforce and a model must judge. Keep them short. Use `create-verification-skill` to stage tests for paths nothing checks.
4. Human review: review does not scale as agents produce more code. Spend review time on repo setup, checks, and architecture, not on reading every routine change.

## Source

Use the current session. Read it fully before deciding. Skip smooth sessions.

## Process

1. Read the `writing-for-agents` skill first. Follow it for every file you propose.
2. Find hard moments. Each one needs a quote or a tool count: a long search, a mistake a tool could catch, a fact you could not find.
3. Drop any moment you cannot trace to one event. Sort the rest by how much harm they cause.
4. Propose the list and wait.
5. Build only what the user picked, with commands you have seen work. Each check must fail on the old code and pass on the fixed code.

## Where fixes go

| What went wrong | Fix it with |
| --- | --- |
| Took long to find a file or fact | A pointer from a file the agent already reads |
| Made a mistake a tool could catch | An automated check: lint, type, test, pre-commit, or CI job |
| Reviewer missed a choice that needs a human eye | A rule in `CODING_STANDARDS.md` |
| `AGENTS.md` or `CLAUDE.md` is large | Move text into standards or checks |
| A tool cost a lot and gave little | Simplify the tool or replace it |
| Lines change nothing | Delete them |
| Needed facts it could not reach | Give it access: a dev log on disk or a read-only service account |

## Rules

- Prefer a check over words. A mistake a tool can catch gets a check. Only a choice no check can catch gets words. If the check works, use the check alone.
- If a check exists but is not wired in, wire it in.
- If the repo has no basic checks, report it. Basic means a pre-commit hook plus a CI job that runs lint, typecheck, and tests.
- Keep standards with the reviewer. The builder is busy searching. Keep `AGENTS.md` to pointers only.
- Prefer a few strong checks. Remove one that fires on good code.
- Say what the session was about. Do not present the list as a full audit.
- This skill stores no memory. It changes the setup so the same mistake cannot happen again.

## Related skills

- Use `code-review` for a verdict on the code. Use this skill for a verdict on the setup.
- Use `improve-codebase` to fix the shape of the code. Use this skill to fix the agent setup.
- Use `sharpen-skills` to change agent behavior. Use this skill to change repo checks, pointers, and standards.

## Finish

Report each fix you proposed, each fix you built, and proof the check runs. List each skipped moment with a one-line reason.
