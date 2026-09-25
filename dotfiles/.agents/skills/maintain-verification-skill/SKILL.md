---
name: maintain-verification-skill
description: "Audits verification skills against code churn, tests unautomated gaps, and promotes stable deterministic paths into native repo E2E tests. Use for /maintain-verification-skill or after feature refactors."
---

# Maintain a Verification Skill

A feature map goes stale as soon as the app changes. A temporary verification workflow should not stay once it is stable. This skill keeps both current: audit docs that no longer match the app, exercise untested features live, and promote stable workflows to permanent repo E2E tests.

## Outcomes

Report one of these outcomes:

- **clean:** Every feature has source and live test coverage. Nothing needs changing.
- **changed:** Proven documentation, harness, or feature map fixes applied.
- **promoted:** One or more stable verification workflows were turned into E2E tests.
- **blocked:** Testing could not finish or a fix could not run safely. Report what blocked the run.

## Edit Scope

Edit only the verification skill directory (`.agents/skills/verify-<app>/`, its `features/` folder, and its harness scripts), unless the pass promotes a workflow to native E2E tests. When promoting, new test files may be added to the project's native test directory (for example, `tests/e2e/`). Never edit product code during this pass. If app behavior differs from the feature map, either the docs are out of date or the app has a bug. If the docs are out of date, update the feature map. If it is a bug, report it to the user.

## Steps

0. Find `.agents/skills/verify-*/`. If no verification skill exists, stop and recommend `create-verification-skill`.
1. Check `features/README.md` against sibling feature files. Remove missing, dead, or duplicate entries.
2. Check repo's native E2E suite: if native E2E tests were added that cover a mapped feature, mark that feature `graduated-to-e2e` and update its driving instructions to run the native test.
3. Inspect the source code for each ungraduated feature file to flag docs that no longer match the app, with line citations, and write a short test plan. Do this directly by default. If there are many ungraduated features, delegate inspection to a single read-only subagent, or batch across at most two. Subagents must never edit files or drive the app.
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
