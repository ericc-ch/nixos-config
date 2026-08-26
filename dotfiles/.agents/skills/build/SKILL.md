---
name: Build
description: Build a feature or task from a spec, ticket, or direct request. Use when the user says "build it", "implement", "do ticket N", or hands you a spec to execute.
metadata:
  opencode/autoinvoke: false
---

# Build

Build what the spec, ticket, or request describes. For nontrivial arcs this routes through the `swe` playbooks (feature, bug-fix, refactoring); this skill is the contract for how any build runs.

## Steps

1. **Read the task.** Ticket requirements and acceptance boxes, or the spec's user stories and decisions. Check `CONTEXT.md` if present.
2. **Design first.** Types, signatures, module shape stated before logic. Data shape chosen per model-the-domain.
3. **Test-first at contracts.** Run the `tdd` loop where a cheap local test path exists: failing test at the public boundary, minimum code to pass, refactor clean.
4. **Check constantly.** Typecheck and tests per unit of work, not in one batch at the end. Full suite when complete.
5. **Verify on the real surface.** Run the feature; screenshot UI work. Inconclusive is a fail.
6. **Review your own diff** with the `review` skill's hostile bar before handing back.
7. **Commit** conventional-style (`feat(scope): ...`), small and ordered, unless told not to.

Report: what shipped, design choices made, verification evidence, open decisions.
