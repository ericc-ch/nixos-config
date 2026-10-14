---
name: code-review
description: "Reviews changes for breakage, extra code, and proof of correctness. Pairs with improve-codebase for the structural pass. Use before commit or PR, for /code-review, diff audits, or pre-merge checks."
---

# Code review

Assume the code is wrong until proven otherwise. Look for bugs, missing edge cases, and safety risks in every line, and report every flaw.

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
- **Enforce the verification proof ladder:**
  - Level 1: "You said so" or "tested manually" (worthless, reject).
  - Level 2: Pointed at line of code (proves syntax, not safety).
  - Level 3: Traced execution path showing the failure cannot reach.
  - Level 4: Executable reproduction script or automated test passing with exit code 0.
  - Level 5: Verified in the running application.
  Reject changes that rely on Level 1 or 2 assertions. Require Level 3 or higher.
- If the repository has a verification skill (`.agents/skills/verify-*/`), confirm the change ran through its harness (`doctor` and `drive`).
- Flag unproven claims as `must-fix`.
- Reject tests that repeat the code instead of checking behavior, or that assert a mock against itself.
- Reject vacuous comments, negative documentation, and notes about removed code. Recommend `no-comments` for comment cleanup.
- Find edge cases, silent failures, performance traps, and security flaws.
- Flag bad abstractions, bloat, and misleading names.
- Flag added complexity when a shorter version keeps the same behavior.
- Label every finding with one `Severity` and one `Kind`.

## Check where grep stops

Do not rely only on symbol search. Check breakages that grep misses:
- **Wire formats and serialization:** JSON keys, API payloads, query parameters, or protocols that callers decode.
- **Data storage and migrations:** Database column renames, schema drift, or records written in an old shape.
- **Lifecycle and timing:** Microtasks, unmount/teardown order, event loop ticks, and async race conditions.
- **Configuration and flags:** Feature flag defaults, environment variable changes, and build-time toggles.
- **Downstream consumers:** Code or services multiple hops away that depend on implicit side effects.

## Severity

Use two levels of severity:

- `must-fix`: Problems that block merging. Examples include broken behavior, logic errors, safety violations, missing requirements, crash bugs, regressions, or missing verification proof.
- `nit`: Non-blocking suggestions. Examples include naming, minor style, small cleanups, or optional polish.

## Kind

Use descriptive categories for the kind of finding. This list is non-exhaustive:

- `bug`: Logic errors, broken edge cases, or behavior that violates contracts.
- `unverified`: Claimed fixes or features without direct runtime proof or test evidence.
- `security`: Authentication flaws, injection risks, input validation gaps, or secret leaks.
- `architecture`: Structural problems, abstractions that expose their internals, or needless complexity.
- `clarity`: Misleading names, confusing control flow, or hard-to-read logic.
- `test`: Missing or inaccurate tests, or tests that repeat the code instead of checking behavior.
- `ui`: Layout flaws, visual styling issues, or broken user interactions.
- `comment`: Vacuous comments, negative documentation, or notes about removed code.
