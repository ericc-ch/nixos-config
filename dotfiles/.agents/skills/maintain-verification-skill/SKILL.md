---
name: maintain-verification-skill
description: "Audits verification skills against code churn, tests unautomated gaps, and promotes stable deterministic paths into native repo E2E tests. Use for /maintain-verification-skill or after feature refactors."
---

# Maintain a Verification Skill

A feature map rots the moment the app changes. This is the upkeep loop for a skill from `create-verification-skill`. Cover every feature from source and live. Keep it linear: inspect directly, drive serially, ship one PR.

## Outcomes

Pick one:

- **clean:** Every feature got source and live coverage. No branch, no PR.
- **changed:** One PR of proven doc, harness, or map corrections.
- **promoted:** One or more stable workflows turned into native E2E tests.
- **blocked:** Coverage could not finish or a fix could not ship safely. Say what blocked it.

## Edit Scope

Only edit the verification skill directory (SKILL.md, `features/`, harness scripts), unless promoting — then native test files may be added (for example, `tests/e2e/`). Never edit product code. Doc drift: fix the map. Product regression: report it, do not paper over it in docs.

## Pass

0. Locate: find `.agents/skills/verify-*/`. Several candidates: ask which. None: stop and point to `create-verification-skill`.
1. Index hygiene: Read the feature map README and glob siblings. Fix missing, extra, duplicate, or dead entries. Lightweight.
2. Source: Inspect each ungraduated feature from source. Flag likely drift with citations and write one live recipe per feature. Do this directly by default. If many features, delegate to at most two read-only subagents. Children never drive the app and never edit files.
3. Reconcile: Merge recipes into as few app states as practical. Spot-check cited drift. Sweep recent churn for user-facing surfaces missing from the map. Require a concrete source path before calling one missing.
4. Live pass: Required even when source looks clean. Follow the skill's launch model: one long-lived instance driven serially for servers/UIs, or a fresh isolated session per drive for short-lived CLIs. Hold three invariants: (1) doctor before first drive, on each fresh session, and after any failed drive — if doctor cannot see the failure, reset or relaunch; (2) evidence captured so far survives every cleanup, checked at its named location; (3) nothing started outlives its usefulness — clean failed-iteration residue, final teardown after the last drive, evidence stays. Doctor failure from skill drift is drift: fix under scope and retry once. Unreachable is `verified-unreachable` only with concrete prerequisite plus route attempted; if the map omits it, that is drift. Re-drive any harness fix before shipping.
5. Triage: Wrong user-POV description: fix doc. Harness cannot drive working behavior: fix harness (scripts executable, invocation in skill body). App behavior broken: record for user, keep out of PR. Stable and deterministic: promote to native E2E spec, mark `graduated-to-e2e`, delegate driving to that test.
6. Ship or stop: `changed`/`promoted`: one PR of proven corrections, re-read every changed file first. `clean`/`blocked`: no PR, report coverage honestly. Keep concise run notes in scratch; do not commit them.
