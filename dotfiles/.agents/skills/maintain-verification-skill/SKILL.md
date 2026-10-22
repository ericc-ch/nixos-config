---
name: maintain-verification-skill
description: "Checks a verification skill against code changes and test gaps, then moves stable paths into native E2E tests. Use for /maintain-verification-skill or after a feature refactor."
---

# Maintain a verification skill

The feature map goes stale as soon as the app changes. This is the upkeep loop for a skill from `create-verification-skill`. Check every feature in the code and in the running app. Work in one pass: inspect directly, drive one at a time, ship one PR.

## Outcomes

Pick one:

- **clean:** Every feature was checked in the code and live. No branch, no PR.
- **changed:** One PR with proven fixes to the docs, driver scripts, or map.
- **promoted:** One or more stable flows became native E2E tests.
- **blocked:** Coverage could not finish, or a fix could not ship safely. Say what blocked it.

## Edit scope

Only edit the verification skill folder (SKILL.md, `features/`, driver scripts). When promoting, you may also add native test files (for example, `tests/e2e/`). Never edit product code. If the docs are wrong, fix the map. If the product is broken, report it. Do not hide it in the docs.

## Pass

0. Find the skill: look for `.agents/skills/verify-*/`. If there are several, ask which one. If there are none, stop and point to `create-verification-skill`.
1. Clean the index: read the feature map README and list its files. Fix missing, extra, duplicate, or dead entries. Keep this quick.
2. Read the source: inspect each feature that has not graduated. Note likely drift with file references, then write one live recipe per feature. Do this yourself by default. If there are many features, use at most two read-only subagents. They must not drive the app or edit files.
3. Reconcile: merge recipes into as few app states as you can. Spot-check the drift you noted. Check recent changes for user-facing features missing from the map. Require a real source path before calling one missing.
4. Run it live: do this even when the source looks clean. Follow the skill's launch model: one long-lived instance driven one at a time for servers and UIs, or a fresh isolated session per run for short-lived CLIs. Keep three rules:

   1. Run the doctor before the first drive, on each fresh session, and after any failed drive. If the doctor cannot see the failure, reset or relaunch.
   2. Evidence captured so far must survive every cleanup. Check it at the named location.
   3. Nothing you start should outlive its use. Clean up failed runs. Tear down after the last drive. Keep the evidence.
   If the doctor fails because the skill is out of date, that is drift: fix it in scope and retry once. Mark a feature `verified-unreachable` only when you have a concrete prerequisite and a route you tried. If the map leaves one out, that is drift. Re-run any fix to a driver script before shipping.
5. Triage: If the user-facing description is wrong, fix the docs. If the driver cannot run working behavior, fix the driver (scripts executable, command shown in the skill body). If the app is broken, record it for the user and keep it out of the PR. If a flow is stable and deterministic, promote it to a native E2E test, mark it `graduated-to-e2e`, and use that test as the way to drive it.
6. Ship or stop: for `changed` and `promoted`, ship one PR of proven fixes. Re-read every changed file first. For `clean` and `blocked`, ship no PR and report coverage honestly. Keep short run notes in scratch. Do not commit them.
