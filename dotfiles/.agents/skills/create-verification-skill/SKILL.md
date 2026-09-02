---
name: create-verification-skill
description: "Generates or refreshes a project skill that drives the real UI, CLI, or HTTP surface and saves evidence. Use when the user asks for a verify skill, or the repo has no way to prove behavior live. Do not use this to run unit tests or to implement a feature."
---

# Create Verification Skill

Generate or refresh a verification skill at `.agents/skills/verify-app/SKILL.md` that runs the app through its external surface and records artifacts.

## Generation Steps

1. Identify entry points and features from the codebase.
2. Assign a driver per surface:
   - Web UI: browser automation with screenshots at each step.
   - HTTP API: requests checking status codes and response bodies.
   - CLI: commands asserting exit codes and stdout/stderr.
   - Background jobs: log output and database state checks.
3. Write `.agents/skills/verify-app/SKILL.md` with:
   - Exact startup and shutdown commands, ports, and health checks.
   - A feature verification table (feature, driver, expected result, artifact output path).
   - Artifact destination directory (`/tmp/verify/<feature>/...`).
4. Execute the verification script end-to-end and fix any failures.

## Refresh Steps

- Audit existing verification steps against current application code.
- Add new features and remove obsolete checks.
- Run the full verification suite to confirm all checks pass.
