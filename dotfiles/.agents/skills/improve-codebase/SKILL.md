---
name: improve-codebase
description: "Surveys the codebase for architectural problems and plans the refactor. Use when the user asks to improve architecture, or when change feels expensive. Big refactors are welcome. Skip small mechanical cleanups."
---

# Improve Codebase

Survey for structural problems, propose candidates, then use the `grilling` skill on the picked one.

## Stance

- Aim for the best design, not the smallest diff. Moving, splitting, merging, and deleting is the work.
- Judge at system level: boundaries, data flow, dependency direction, duplicate concepts.
- Best practice beats local convention. Size alone never rejects a candidate.
- Keep behavior unchanged unless the plan says otherwise.

## Steps

1. Scope: if the user named an area, use it. Else check `git log --oneline` for hot spots and weight recent changes. Widen if scattered. Read the surrounding system.
2. Survey: walk for friction: bouncing between modules to grasp one idea, interface almost as big as implementation, helpers pulled out for tests while bugs live in callers, leaks across seams, hard-to-test interface. Deletion test: would deleting concentrate complexity or just move it.
3. Report: for each candidate list files, problem in concrete terms (what breaks, what it costs, where), plain fix, how tests improve, and strength (`Strong`, `Worth exploring`, `Speculative`). Recommend one top pick. Rank higher when it removes concepts. No interfaces yet. Ask which to explore.
4. Grill the pick: sketch two distinct shapes before choosing. Prefer the deep interface: more behavior behind a smaller surface. Prefer the shape where the obvious next move is the correct one.
5. Execute in small steps ending in a passing check. Steps limit risk, not scope. Verify behavior unchanged each step. If the same workaround, cast, or caller-knows-internals repeats, scrap and restart smaller. State decisions in the landing commit.
