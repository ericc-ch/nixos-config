---
name: improve-codebase
description: "Finds architectural cleanup candidates, reports them, then interviews on the one the user picks. Use when change feels expensive, they ask to improve architecture, or they want a refactor survey. Do not start a large reshape until they pick a candidate. Known mechanical refactors (rename, extract, dedupe) need no survey."
---

# Improve Codebase

Find where the codebase fights back, propose deep-module reshapes, and settle the plan through `grilling`. A survey, not a rescue: old codebases yield real candidates; none get untangled automatically.

## Design bar (Ousterhout)

- **Deep module:** small interface hiding substantial work. **Shallow module:** wide interface doing little. Shallow is the smell.
- Pass dependencies in; return outputs; no hidden global state.
- Tests hold through internal refactors as long as public behavior stands.

## Steps

1. **Survey active code.** `git log --oneline` for churn hotspots. Look for: modules split into too many tiny files, logic that resists testing, coupled components leaking internals, untested public APIs, conditionals begging to be a table or state machine.
2. **Report.** For each candidate: files involved, the friction in plain words, proposed reshape, before/after sketch, level (`Strong` / `Worth exploring` / `Speculative`). End with your top pick and why.
3. **Interview the chosen one** via `grilling`: constraints, dependencies, the new interface shape, what hides behind it, which tests survive.
4. **Record decisions:** new or sharpened terms go to `docs/CONTEXT.md`; rejected candidates with real reasons get an ADR under `docs/adrs/` so future surveys stop re-suggesting them.
5. **Execute:** pin current behavior first (characterization test), then refactor in small steps, each keeping the pin green.

Run this every few days on active repos; entropy compounds faster than reviews.
