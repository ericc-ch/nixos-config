---
name: create-verification-skill
description: "Creates a project-local verification skill when E2E tests are missing or incomplete. Explores user flows, finds a path that works every time, and stages it for promotion into the native E2E suite. Skip when a working verify skill or full E2E coverage exists."
---

# Create a verification skill

When E2E tests are missing or leave gaps, create a project-local verification skill (`.agents/skills/verify-<app>/`). It is temporary. It maps the gaps, proves a path that works every time, and stages the flow for promotion into the native E2E suite.

## 1. Learn from the repo, not the user

Answer from the codebase. Ask the user only what you cannot observe:

- Existing E2E and gaps: what already exists (Playwright, Cypress, Bats, curl suites)? Focus only on untested gaps.
- User entry points: what does a user touch? Web UI, CLI/TUI, desktop, API, mobile, library? Pick the main one and note the rest.
- Run: prefer the repo's documented dev command (scripts, Makefile, README). Note ports, env vars, seed data, and auth.
- Drive: use an existing automation tool first. Only then pick a generic one: browser/CDP for web or Electron, tmux/PTY for CLI/TUI, HTTP for services.
- Observe: screenshots, transcripts, response bodies, logs, exit codes, database state.
- Isolate: can two runs use the same machine side by side (ports, data folders, profiles)? If not, say so. Run one at a time rather than corrupt a session.

If the checkout does not build or start, fix that first. A skill written against a broken base teaches wrong steps.

## 2. Write the skill

Write `.agents/skills/verify-<app>/SKILL.md` with frontmatter (`name: verify-<app>` and a clear `description`). Leave no placeholders. Include:

- Launch: the exact command and how to tell it is ready (log line, prompt). It must work from an empty data folder, including migrations and seed. Ready means usable, not just that the process answers. For a short-lived CLI, build once, then run each drive in its own isolated PTY or tmux session. Save PIDs for cleanup.
- Doctor: one read-only check: process up, right version, port owned by us, auth valid. Run it first when anything looks off.
- Drive: real selectors and commands from this repo. Prefer stable handles (ARIA labels, data attributes, prompt strings, routes) over coordinates and tab order.
- Evidence: what to capture and where (for example, `.audit/evidence/`). Standards: a real user path, not internal setters or test-only endpoints; capture the action and the resulting state; check side effects (files, rows, messages); use mocks only where a production boundary isolates the code; check dry-run skips by observing, not by trusting the name.
- Cleanup: tear down what you started. Never kill by process name. Evidence survives cleanup.
- Helpers: scripts are executable and the command is shown in the body.

## 3. Seed the feature map

Create `.agents/skills/verify-<app>/features/README.md` plus one file per feature (the top 3 to 5 gaps nothing automates). Each file uses:

- `## Status` (`draft`, `deterministic`, or `graduated-to-e2e`)
- `## Sub-features`
- `## How to get to it (user POV)`
- `## Driving it with <harness>`
- `## Gotchas`
- `## Promotion Criteria` (assertions and setup needed to turn this into a CI E2E spec)

If the seed data lacks a precondition, report it under `Gotchas`. Never weaken the flow to make it pass.

## 4. Prove it before handing over

Run its own instructions end to end once: Launch, Doctor, drive one mapped feature, capture evidence, Cleanup, and confirm the evidence survived. Clean up after every failed run too. Fix what fails. A skill that was never run is a draft, not ready to hand over. If you proved it against a stand-in (a different app or environment), list what the stand-in did that the target will not.

## 5. Promote and maintain

- Once it is `deterministic` and passes repeatedly, promote it into a native spec (for example, `tests/e2e/<feature>.spec.ts`).
- Update the status to `graduated-to-e2e` and use that test command to drive it.
- Point the user to `maintain-verification-skill` for upkeep.
