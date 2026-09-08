---
name: maintain-verification-skill
description: "Audits verification skills against code churn, tests unautomated gaps, and promotes stable deterministic paths into native repo E2E tests. Use for /maintain-verification-skill or after feature refactors."
---

# Maintain a Verification Skill

A feature map rots the moment the app changes, and temporary verification workflows should not linger indefinitely once stable. This skill is the upkeep and promotion loop: audit documentation drift, exercise gap features live, and promote deterministic workflows to permanent repo E2E specs.

## Outcomes

Report one of these outcomes:
- **clean:** Every feature has source and live test coverage. Nothing needs changing.
- **changed:** Proven documentation, harness, or feature map fixes applied.
- **promoted:** One or more deterministic verification workflows were codified into native E2E test specs.
- **blocked:** Testing could not finish or a fix could not run safely. Report what blocked the run.

## Edit Scope

Only edit the verification skill directory (`.agents/skills/verify-<app>/`, its `features/` folder, and harness scripts) UNLESS performing an explicit E2E promotion. When promoting, new test files may be added to the project's native test directory (e.g. `tests/e2e/`). Never edit product code during this pass. If app behavior differs from the feature map, it is either documentation drift or a bug in the app. If it is documentation drift, update the feature map. If it is a bug, report it to the user.

## Steps

0. Find `.agents/skills/verify-*/`. If no verification skill exists, stop and recommend `create-verification-skill`.
1. Check `features/README.md` against sibling feature files. Remove missing, dead, or duplicate entries.
2. Check repo's native E2E suite: if native E2E tests were added that cover a mapped feature, mark that feature `graduated-to-e2e` and update its driving instructions to run the native test.
3. If subagents are available, spawn one read-only subagent per ungraduated feature file. Each subagent inspects the feature source code, flags documentation drift with line citations, and returns a test recipe. Subagents must never edit files or drive the app.
4. Merge recipes into efficient execution flows. Check recent git commits for new user-facing features missing from both the E2E suite and the feature map.
5. Drive every ungraduated feature live using the Launch and Drive instructions in the verification skill.
   - Run the Doctor check before driving.
   - Ensure captured evidence survives all cleanups.
   - Ensure no background processes or scratch state outlive the run.
   - Re-run any modified harness scripts before finishing.
6. Sort findings into four categories:
   - Wrong user description: Update the feature file.
   - Harness cannot drive working feature: Fix the harness script.
   - App behavior broken: Document the bug for the user.
   - Workflow is stable & deterministic: Promote to native E2E test spec, update status to `graduated-to-e2e`, and delegate driving commands.
7. Summarize test coverage, confirmed drift, unreached features, and any newly promoted E2E tests.
