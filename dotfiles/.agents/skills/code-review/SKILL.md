---
name: code-review
description: Review code changes against a target commit or branch for spec compliance and coding standards.
---

# Code Review

Review code changes between current work (`HEAD`) and a baseline commit or branch.

## Review Structure

Check changes against two separate lists:

1. **Spec Compliance:** Does the code fulfill every requirement in the issue or specification?
2. **Coding Standards:** Does the code follow project style rules, the `code-conventions` skill, and maintainable design?

---

## Steps

### 1. Select the comparison target and scope

Identify the baseline commit or branch. Default to `main` or `master` if unstated. Scope the review strictly to changed files. Run `git diff <target>...HEAD`, or `git diff HEAD` for uncommitted working tree changes.

### 2. Locate the spec

Find the originating spec, issue description, or PRD.

### 3. Review for Spec Compliance

Verify:

- Every requested requirement is present.
- No unrequested feature bloat (scope creep) was added.
- Implementation logic matches expected spec behavior.

### 4. Review for Coding Standards

Check against repo style files (such as `CODING_STANDARDS.md`) and the `code-conventions` skill. Also check for common code flaws:

- **Unclear names:** Function or variable names that do not explain their purpose.
- **Duplicate code:** Identical logic repeated across multiple files.
- **Overly complex functions:** Methods that handle too many responsibilities at once.
- **Unused parameters or code:** Speculative code added for features not requested in the spec.
- **Low-value tests:** Tests that duplicate the type checker, mock external third-party shapes, or assert on static existence rather than behavioral contracts (see `/tdd`).

### 5. Report Findings

List findings under two clear headers: `## Spec Compliance` and `## Coding Standards`.
