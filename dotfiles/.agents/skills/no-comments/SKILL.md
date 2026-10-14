---
name: no-comments
description: "Removes unnecessary comments from code and encodes invariants into types, assertions, or tests. Use for /no-comments, cleaning up diffs, or comment debt audits."
---

# No comments

Code explains *how*; tests and commit history explain *why*. Unnecessary comments rot, drift from behavior, and clutter the codebase.

Audit comments in the target scope, remove clutter, and encode true constraints into code.

## Scope

Use the files specified by the caller, or the current diff against `main`.

## Process

### 1. Classify and prune comments

Scan every comment in scope and place it into one of three categories:

- **Trivial and narrative comments (Delete):**
  - Comments that restate what the next line does (`// increment count`, `// return response`).
  - Narrative step markers (`// Step 1: parse input`, `// Step 2: process`).
  - Commented-out dead code or historical notes about removed functions.
  - Vacuous docstrings that repeat function or parameter names.
  *Action:* Delete immediately.

- **Invariants and constraints (Encode, then delete):**
  - Comments warning about safety rules, ordering dependencies, or delicate constraints (`// do not remove`, `// must be called before save()`, `// keep in sync with API schema`).
  *Action:* Convert the constraint into automated code enforcement before deleting the comment:
    1. A stricter type definition or interface constraint.
    2. A runtime assertion or invariant check (`assert(state.initialized)`).
    3. A focused unit or regression test.
    4. A linter or compiler check.
  Once the invariant is enforced in code, delete the comment.

- **External unfixable constraints (Keep):**
  - Workarounds for third-party library bugs, browser quirks, OS or hardware defects, or upstream protocol oddities that cannot be fixed in this codebase.
  *Action:* Keep only if the comment provides an exact issue link, upstream bug URL, or CVE, and explains why the workaround is necessary.

### 2. Verify

Run the project test suite, compiler, and linter to prove that:
- Deleting comments introduced no syntax errors or typos.
- Any newly added assertions or type constraints pass cleanly without breaking existing valid behavior.

### 3. Report

Provide a concise summary:
- Total comments removed.
- Constraints converted into types, runtime assertions, or tests.
- Remaining comments preserved for external constraints (with URLs).
