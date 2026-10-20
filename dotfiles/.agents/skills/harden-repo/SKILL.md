---
name: harden-repo
description: "Hardens repo setup from hard sessions. Use after the agent struggled to find files, repeated a preventable mistake, or lacked logs or access. Skip personal style lessons, use `sharpen-skills` instead. Skip code verdicts, use `code-review` instead."
---

Propose repo fixes from one hard session. Change the setup, not the code. Propose only. Change nothing until the user picks.

## Hardening priorities

Order interventions by leverage:

1. Codebase improvements: Architecture, strict types, invariants, and clear boundaries. Agents copy existing patterns and take the shortest path. Eliminate failure modes in code so the correct path is easiest. Use the `improve-codebase` skill.
2. Static analysis: Linters, type checks, tests, CI pipelines, and formal verification (for example, TLA+). Deterministic checks catch issues early without token cost.
3. Prose: Comments, rules, instruction files (`AGENTS.md`), and skills. Use prose only for choices that tools cannot enforce and that require model judgment. Keep prose minimal. Use the `create-verification-skill` to stage tests for unautomated paths.
4. Human review: Review scales poorly as agent throughput increases. Spend review effort on repository setup, checks, and architecture instead of line-by-line inspection of routine changes.

## Source

Use the current session. Read it fully before deciding. Skip smooth sessions.

## Process

1. Read the `writing-for-agents` skill first. Follow it for every file you propose.
2. Find hard moments. Each needs a quote or a tool count: long search, mistake a tool could catch, missing facts.
3. Drop any you cannot trace to one moment. Order the rest by harm.
4. Propose the list and wait.
5. Build only what the user picked, with commands you have seen work. Each check must fail on old code and pass on fixed code.

## Where fixes go

| What went wrong                              | Fix it with                                                 |
| -------------------------------------------- | ----------------------------------------------------------- |
| Took long to find a file or fact             | A pointer from a file the agent already reads               |
| Made a mistake a tool could catch            | An automated check: lint, type, test, pre-commit, or CI job |
| Reviewer missed a choice needing a human eye | A rule in `CODING_STANDARDS.md`                             |
| `AGENTS.md` or `CLAUDE.md` is large          | Move text out into standards or checks                      |
| A tool cost much and gave little             | Streamline the tool or replace it                           |
| Lines change nothing                         | Delete those lines                                          |
| Needed facts it could not reach              | Widen access: dev log on disk or read-only service access   |

## Rules

- Prefer a check over words. A mistake a tool can catch gets a check. Only a choice no check can catch gets prose. If the check works, use the check alone.
- If a check exists but is not wired, wire it.
- If the repo has no basic checks, report it. Basic means a pre-commit hook plus a CI job running lint, typecheck, and tests.
- Keep standards with the reviewer. The builder is busy searching. Keep `AGENTS.md` to pointers only.
- Prefer few strong checks. Remove one that fires on good code.
- Say what the session was about. Do not present the list as a full audit.
- This skill stores no memory. It changes the setup so the same mistake cannot repeat.

## Relation to nearby skills

- Use `code-review` for a verdict on the code. Use this skill for a verdict on the setup.
- Use `improve-codebase` to fix code shape. Use this skill to fix agent setup.
- Use `sharpen-skills` to change agent behavior. Use this skill to change repo checks, pointers, and standards.

## Close out

Report each candidate proposed, each fix built, and proof the check runs. List each skipped moment with a one line reason.
