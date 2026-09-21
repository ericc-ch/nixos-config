---
name: code-review
description: "Reviews changes for breakage, extra code, and proof of correctness. Pairs with improve-codebase for the structural pass. Use before commit or PR, for /code-review, diff audits, or pre-merge checks."
---

# Code review

Audit code diffs with an adversarial stance. Assume the code contains bugs, missing edge cases, and safety risks until proven otherwise. Audit every line and report every flaw.

The default review scope is the current diff against `main`, unless the user specifies a PR, path, or commit range.

Read the `improve-codebase` skill along with this one.

## Subagent delegation

- **If you worked on the code:** Spawn one or more subagents based on diff size and complexity. For example, split by subsystem or focus areas such as correctness, security, or edge cases. Fresh context removes author bias.
  - Instruct each subagent to read `code-review` and `improve-codebase` first.
  - Have each subagent return findings grouped by severity and kind.
  - Consolidate and deduplicate findings into a single unified report.
- **If you are reviewing (you did not write the code):** Do not spawn subagents. Conduct the review directly. You already have fresh context.

## Rules

- Check code against `code-conventions` and repository rules.
- Check verification proof. Reject changes that lack concrete evidence, such as reproduction command output, test runs, screenshots, or exit codes. Never accept "it compiles" or "tested manually" without proof.
- If the repository has a verification skill (`.agents/skills/verify-*/`), confirm the change ran through its harness (`doctor` and `drive`).
- Flag unproven claims as `must-fix`.
- Reject tautological tests that mirror implementation details or assert mock configuration against itself.
- Reject vacuous comments, negative documentation, and notes about removed code.
- Find edge cases, silent failures, performance traps, and security flaws.
- Flag bad abstractions, bloat, and misleading names.
- Flag added complexity when a shorter version keeps the same behavior.
- Label every finding with one `Severity` and one `Kind`.

## Severity

Use two levels of severity:

- `must-fix`: Problems that block merging. Examples include broken behavior, logic errors, safety violations, missing requirements, crash bugs, regressions, or missing verification proof.
- `nit`: Non-blocking suggestions. Examples include naming, minor style, small cleanups, or optional polish.

## Kind

Use descriptive categories for the kind of finding. This list is non-exhaustive:

- `bug`: Logic errors, broken edge cases, or behavior that violates contracts.
- `unverified`: Claimed fixes or features without direct runtime proof or test evidence.
- `security`: Authentication flaws, injection risks, input validation gaps, or secret leaks.
- `architecture`: Structural problems, leaky abstractions, or needless complexity.
- `clarity`: Misleading names, confusing control flow, or hard-to-read logic.
- `test`: Missing, inaccurate, or tautological tests.
- `ui`: Layout flaws, visual styling issues, or broken user interactions.
- `comment`: Vacuous comments, negative documentation, or notes about removed code.
