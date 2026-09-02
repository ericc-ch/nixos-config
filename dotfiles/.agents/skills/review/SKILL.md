---
name: review
description: "Reviews a change against the request and coding standards, then probes breakage, extra code, and readability. Default scope is the current git diff (uncommitted, or the branch vs main). Use before commit or PR, when asked to review, or after a nontrivial change. Can review a named PR, path, or commit range if the user specifies one."
---

# Review

Assume whoever wrote the code was a complete idiot. Assume the code is broken, incompetent, and full of bugs until proven otherwise. Give zero benefit of the doubt. Ruthlessly audit every line and report every single flaw.

Default scope is the current diff against `main`, unless the user specifies a PR, path, or commit range.

## Review Rules

- Verify code against the `code-conventions` skill and repository rules.
- Hunt down edge cases, silent failures, performance traps, and security holes.
- Call out bad abstractions, bloat, and sloppy naming.
- Label every finding with one `Severity` and one `Kind`.

## Severity

- `must-fix`: Broken behavior, safety violation, or crash bug.
- `should-fix`: Logic flaw, missed requirement, or code defect.
- `nit`: Naming, minor style, or non-critical improvement.

## Kind

- `bug`: Behavior violates specifications or contracts.
- `security`: Auth flaws, input validation gaps, or secret leaks.
- `test`: Missing or inaccurate test coverage.
- `design`: Architecture violations, leaky abstractions, or needless complexity.
- `clarity`: Ambiguous control flow or misleading variable names.
