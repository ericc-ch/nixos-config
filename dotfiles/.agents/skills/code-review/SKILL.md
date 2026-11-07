---
name: code-review
description: "Reviews changes for breakage and extra code. Pairs with `improve-codebase` for the structural pass. Use before commit or PR, for /code-review, diff audits, or pre-merge checks."
---

# Code review

Review the diff between `HEAD` and a fixed point. Answer two questions separately:

- **Standards:** does the code follow this repo's rules?
- **Spec:** does it do what the spec or issue asked, and nothing more?

A change can pass one and fail the other. Report them side by side so one cannot hide the other.
If the scope is not provided, ask for it (PR, path, or commit range) before starting.

## Pin the fixed point

Use the commit, branch, tag, or PR the user named. Capture `git diff <ref>...HEAD` (three dots, against the merge base) and `git log <ref>..HEAD --oneline`. Confirm the ref resolves and the diff is not empty before starting.

## Find the spec

Check commit messages for issue references (`#123`, `Closes #45`), then a path the user passed, then a file under `docs/`, `specs/`, or `.scratch/`. If nothing turns up, ask. With no spec, skip the Spec axis and say so.

## Find the standards

List the files that say how code should be written. Include `CODING_STANDARDS.md` and `CONTRIBUTING.md` when they exist, plus the `code-conventions` skill. Skip what tooling already enforces.

Then apply the smell baseline below. A documented repo rule overrides it. Every smell is a judgement call, not a hard violation.

- **Mysterious name:** the name does not say what the thing does. Rename it. If no honest name comes, the design is murky.
- **Duplicated code:** the same logic shape in more than one hunk. Extract it and call it from both.
- **Feature envy:** a method reaches into another object's data more than its own. Move it onto that data.
- **Data clumps:** the same few fields or parameters keep travelling together. Bundle them into one type.
- **Primitive obsession:** a string or number stands in for a domain concept. Give the concept its own type.
- **Repeated switches:** the same switch or if-cascade on the same type in several places. Use one map or polymorphism.
- **Shotgun surgery:** one logical change forces scattered edits across many files. Gather what changes together.
- **Divergent change:** one file changes for several unrelated reasons. Split it.
- **Speculative generality:** parameters or abstractions for a need the spec does not have. Delete them.
- **Message chains:** long `a.b().c().d()` navigation. Hide the walk behind one method.
- **Middle man:** a class or function that mostly delegates. Call the real target.
- **Refused bequest:** a subclass ignores most of what it inherits. Use composition.

## Run both axes

If you wrote the changes, use one subagent per axis, in parallel. If you did not, review directly.

## Rules

- Use the `code-conventions` skill. Check code against it and repository rules.
- If the repository has a verification skill (`.agents/skills/verify-*/`), confirm the change ran through its harness (`doctor` and `drive`).
- Find edge cases, silent failures, performance traps, and security flaws.
- Flag bad abstractions, bloat, and misleading names.
- A short, naive change is not simple. Do not flag a change just because it is big. Flag it when it adds concepts or hides behavior.
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

## Report

Use `## Standards` and `## Spec` headings. Keep the axes separate. Do not merge or rerank findings.

End with one line per axis: the count, and the worst issue in that axis. Do not pick one winner across both.
