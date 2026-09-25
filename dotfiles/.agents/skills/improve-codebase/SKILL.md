---
name: improve-codebase
description: "Surveys the codebase for architectural problems and plans the refactor. Use when the user asks to improve architecture, or when change feels expensive. Big refactors are welcome. Skip small mechanical cleanups."
---

# Improve Codebase

Survey the repository for structural problems, propose refactoring candidates, and align on a plan with the `grilling` skill.

## Stance

- Aim for the best design, not the smallest diff.
- Moving, splitting, merging, and deleting code is the work, not a cost to avoid.
- Judge each candidate at the system level: module boundaries, data flow, dependency direction, and duplicate concepts. A local fix that preserves a bad shape wastes the pass.
- Let best practice outrank local convention. "The codebase already does it this way" is not a design argument.
- Size alone is not a reason to reject a candidate. One large refactor that removes a permanent cost beats a series of small patches that keep the cost.
- Keep external behavior unchanged, unless the plan says otherwise.

## Steps

1. **Survey**
   - Check `git log --oneline` for high-churn files.
   - Read the surrounding system, not only the flagged files.
   - Locate coupled modules, split-up domain logic, wide interfaces, hidden global state, and duplicate representations of one concept.

2. **Report candidates**
   - For each candidate, list:
     - Target files.
     - The structural problem in concrete terms: what breaks, what it costs, and where.
     - Proposed redesign.
     - Confidence level (`Strong`, `Worth exploring`, `Speculative`).
   - Recommend one top candidate.
   - Rank candidates higher when the redesign removes concepts, not just lines, and keeps external behavior unchanged.
   - Do not drop a candidate because it is large.

3. **Interview**
   - Run the `grilling` skill on the chosen candidate to resolve interfaces and constraints before editing code.

4. **Record decisions**
   - State the design decisions in the commit message that lands the refactor.

5. **Execute**
   - Sequence the refactor into small, verifiable steps. Each step ends in a check that passes.
   - Steps limit risk, not scope. Do not shrink the design to make the steps smaller.
   - Verify that external behavior stays unchanged after each step.
