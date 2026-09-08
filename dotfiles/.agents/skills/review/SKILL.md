---
name: review
description: "Reviews changes for breakage, extra code, and proof of correctness. Use before commit or PR, for /review, diff audits, or pre-merge checks. Skip for uncommitted scratch experiments or simple typo fixes."
---

# Review

Audit code diffs with an adversarial stance. Assume the code contains bugs, missing edge cases, and safety risks until proven otherwise. Audit every line and report every flaw.

The default review scope is the current diff against `main`, unless the user specifies a PR, path, or commit range.

## Subagent Delegation

- **If you worked on the code:** Spawn one or more subagents as needed (if supported) based on diff size and complexity (e.g., split by subsystem or focus areas like correctness, security, or edge cases). Fresh context removes author bias.
  - Instruct each subagent to read this `review` skill first and follow its adversarial rules.
  - Have each subagent return structured findings grouped by Severity and Kind.
  - Consolidate and deduplicate findings into a single unified report.
- **If you are reviewing (you didn't write the code):** Do not spawn subagents. Conduct the review directly yourself—you already have fresh, unbiased context.

## Rules

- Check code against `code-conventions` and repository rules.
- Check verification proof. Reject changes that lack concrete evidence (reproduction command output, test runs, screenshots, or exit codes). Never accept "it compiles" or "tested manually" without proof.
- If the repository has a verification skill (`.agents/skills/verify-*/`), confirm the change was run through its harness (`doctor` and `drive`).
- Flag unproven claims as `must-fix`.
- Reject tautological tests that mirror implementation details or assert mock configuration against itself.
- Reject vacuous comments, negative documentation, and notes about removed code.
- Find edge cases, silent failures, performance traps, and security flaws.
- Flag bad abstractions, bloat, and misleading names.
- Flag added complexity when a shorter version keeps the same behavior.
- Label every finding with one `Severity` and one `Kind`.

## Severity

- `must-fix`: Broken behavior, missing verification proof, safety violation, or crash bug.
- `should-fix`: Logic flaw, missed requirement, or code defect.
- `nit`: Naming, minor style, or non-critical improvement.

## Kind

- `bug`: Behavior violates specifications or contracts.
- `unverified`: Claimed fix or feature lacks direct runtime proof or evidence.
- `security`: Auth flaws, input validation gaps, or secret leaks.
- `test`: Missing, inaccurate, or tautological test coverage.
- `comment`: Vacuous comment, negative documentation, or note about removed code.
- `design`: Architecture violations, leaky abstractions, or needless complexity.
- `clarity`: Ambiguous control flow or misleading variable names.
