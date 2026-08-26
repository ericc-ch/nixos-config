---
name: deepen
description: Survey a codebase for architectural cleanup candidates (shallow modules, tangled layers), report them visually, then grill through the one you pick. Use for "improve the architecture", periodic upkeep, or when change feels expensive.
---

# Deepen

Find where the codebase fights back, propose deep-module reshapes, and settle the plan through grilling. A survey, not a rescue: old codebases yield real candidates; none get untangled automatically.

## Design bar (Ousterhout)

- **Deep module:** small interface hiding substantial work. **Shallow module:** wide interface doing little. Shallow is the smell.
- Pass dependencies in; return outputs; no hidden global state.
- Tests hold through internal refactors as long as public behavior stands.

## Steps

1. **Survey active code.** `git log --oneline` for churn hotspots. Look for: modules split into too many tiny files, logic that resists testing, coupled components leaking internals, untested public APIs, conditionals begging to be a table or state machine.
2. **Report.** Standalone HTML at `/tmp/architecture-<timestamp>.html`, open it (`xdg-open`). One card per candidate: files involved, the friction in plain words, proposed reshape, before/after sketch, level (`Strong` / `Worth exploring` / `Speculative`). End with your top pick and why.
3. **Grill the chosen one** via `grill`: constraints, dependencies, the new interface shape, what hides behind it, which tests survive.
4. **Record decisions:** new or sharpened terms go to `CONTEXT.md`; rejected candidates with real reasons get an ADR so future surveys stop re-suggesting them.
5. Execute through the refactoring playbook (pin behavior first).

Run this every few days on active repos; entropy compounds faster than reviews.
