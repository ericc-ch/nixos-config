---
name: make-verify-skill
description: "Generates or refreshes a project skill that drives the real UI, CLI, or HTTP surface and saves evidence. Use when the user asks for a verify skill, or the repo has no way to prove behavior live. Do not use this to run unit tests or to implement a feature."
---

# Make Verify Skill

Give the project a way to prove itself: a generated `.agents/skills/verify-app/` skill that starts the app, exercises every feature through its real surface, and shows the evidence.

## Generate

1. **Map the app.** Entry points, features, how each proves it works (page renders, endpoint answers, command exits zero). Read source and run scripts; do not guess.
2. **Pick drivers per surface:** web UI (browser automation, screenshot at each step), HTTP service (curl with expected status/body), CLI (invocation plus output assertion), background jobs (log or state assertions).
3. **Write the skill** at `.agents/skills/verify-app/SKILL.md` containing:
   - How to start and stop the app (exact commands, ports, readiness check).
   - A feature table: feature → driver → proof → evidence artifact path.
   - The rule: every claim needs live evidence; a screenshot, response body, or exit code. "It compiles" is not proof.
   - Where artifacts land (`/tmp/verify/<feature>/...`).
4. **Run it once end to end.** Fix the skill until a cold run passes without improvisation.

## Audit (refresh)

Re-read the feature map against current source; add missing features, retire dead ones, drive every feature once in a live session, and correct the skill from what actually happened. One PR of proven corrections.

Evidence over confidence: the eye is a test for visuals, the observed number is a test for behavior.
