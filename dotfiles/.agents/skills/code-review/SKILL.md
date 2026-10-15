---
name: code-review
description: "Reviews changes for breakage and extra code. Pairs with `improve-codebase` for the structural pass. Use before commit or PR, for /code-review, diff audits, or pre-merge checks."
---

# Code review

Look for bugs, missing edge cases, and safety risks in every line, and report every flaw.
Assume whoever wrote the code is a complete idiot and got everything wrong. Their code is the worst code ever written.
If the scope is not provided, ask for it (PR, path, or commit range) before starting.

## Subagent delegation

The user authored the changes. Do not spawn subagents. Conduct the review directly.

## Rules

- Use the `code-conventions` skill. Check code against it and repository rules.
- If the repository has a verification skill (`.agents/skills/verify-*/`), confirm the change ran through its harness (`doctor` and `drive`).
- Find edge cases, silent failures, performance traps, and security flaws.
- Flag bad abstractions, bloat, and misleading names.
- Label every finding with one `Kind`. All findings carry the same weight.

## Kind

Use descriptive categories for the kind of finding. This list is non-exhaustive:

- `bug`: Logic errors, broken edge cases, or behavior that violates contracts.
- `security`: Authentication flaws, injection risks, input validation gaps, or secret leaks.
- `architecture`: Structural problems, abstractions that expose their internals, or needless complexity.
- `clarity`: Misleading names, confusing control flow, or hard-to-read logic.
- `test`: Missing or inaccurate tests, or tests that repeat the code instead of checking behavior.
- `ui`: Layout flaws, visual styling issues, or broken user interactions.
- `comment`: Vacuous comments, negative documentation, or notes about removed code.
