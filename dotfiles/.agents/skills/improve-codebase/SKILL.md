---
name: improve-codebase
description: "Finds architectural cleanup candidates, reports them, then interviews on the one the user picks. Use when change feels expensive, they ask to improve architecture, or they want a refactor survey. Do not start a large reshape until they pick a candidate. Known mechanical refactors (rename, extract, dedupe) need no survey."
---

# Improve Codebase

Survey the repository for structural bottlenecks, propose refactoring candidates, and align on a plan via the `grilling` skill.

## Steps

1. **Survey**
   - Check `git log --oneline` for high-churn files.
   - Locate coupled modules, split-up domain logic, wide interfaces, and hidden global state.

2. **Report Candidates**
   - For each candidate list:
     - Target files.
     - Specific structural friction.
     - Proposed redesign.
     - Confidence level (`Strong`, `Worth exploring`, `Speculative`).
   - Recommend one top candidate.

3. **Interview**
   - Run the `grilling` skill on the chosen candidate to resolve interfaces and constraints before editing code.

4. **Record Decisions**
   - Add new domain terms to `docs/CONTEXT.md`.
   - Write an Architecture Decision Record (ADR) under `docs/adrs/` for major structural changes or rejected options.

5. **Execute**
   - Refactor in small, incremental steps.
   - Verify that external behavior remains unchanged after each step.
