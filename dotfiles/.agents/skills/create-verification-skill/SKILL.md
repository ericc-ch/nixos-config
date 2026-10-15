---
name: create-verification-skill
description: "Generates a project-local verification skill to fill gaps left by missing E2E tests. Explores user workflows, finds deterministic paths, and stages them for promotion into permanent E2E tests. Skip when working verify skill or full E2E coverage already exists."
---

# Create a Verification Skill

When automated E2E tests do not exist or leave gaps, generate a project-local verification skill (`.agents/skills/verify-<app>/`). It is temporary. It maps the gaps, proves a deterministic path, and stages the workflow for promotion into the native E2E suite.

## 1. Interview the repo, not the user

Answer from the codebase. Only ask the user what you cannot observe:

- Existing E2E & Gaps: What E2E already exists (Playwright, Cypress, Bats, curl suites)? Focus ONLY on untested gaps.
- Surface: What does a user touch? Web UI, CLI/TUI, desktop, API, mobile, library? Pick the primary, note the rest.
- Run: Prefer the repo's documented dev command (scripts, Makefile, README). Note ports, env vars, seed data, auth.
- Drive: Existing harnesses first. Only then pick generic: browser/CDP for web/Electron, tmux/PTY for CLI/TUI, HTTP for services.
- Observe: Screenshots, transcripts, bodies, logs, exit codes, DB state.
- Isolate: Can two run side by side (ports, data dirs, profiles)? If not, say so. Refusing to double-drive beats corrupting the session.

If the checkout does not build or start, fix that first. A skill written against a broken base teaches wrong steps.

## 2. Generate the skill

Write `.agents/skills/verify-<app>/SKILL.md` with frontmatter (`name: verify-<app>` and a clear `description`). No placeholders left. Include:

- Launch: Exact command and how to tell it is ready (log line, prompt). Must reach usable from an empty data dir, including migrations and seed. Ready means usable, not just process answers. Short-lived CLI: build once, each drive in its own isolated PTY/tmux. Save PIDs for cleanup.
- Doctor: One read-only check: process up, right version, port owned by us, auth valid. Run first when anything looks off.
- Drive: Real selectors/commands from this repo. Prefer stable handles (ARIA labels, data attributes, prompt strings, routes) over coords and tab order.
- Evidence: What to capture and where (for example, `.audit/evidence/`). Standards: real user path, not internal setters or test-only endpoints; capture action plus resulting state; verify side effects (files, rows, messages); mocks only where a production boundary isolates; verify dry-run skips by observing, not trusting the name.
- Cleanup: Tear down what you started. Never kill by process name. Evidence survives cleanup.
- Helpers: Scripts are executable and invocation is shown in the body.

## 3. Seed the feature map

Create `.agents/skills/verify-<app>/features/README.md` plus one file per feature (top 3-5 unautomated gaps). Each file uses:

- `## Status` (`draft`, `deterministic`, or `graduated-to-e2e`)
- `## Sub-features`
- `## How to get to it (user POV)`
- `## Driving it with <harness>`
- `## Gotchas`
- `## Promotion Criteria` (assertions and setup to turn this into a CI E2E spec)

If seed data lacks a precondition, report failure in `Gotchas`. Never weaken the journey to make it pass.

## 4. Prove before handing over

Run its own instructions end to end once: Launch, Doctor, drive ONE mapped feature, capture evidence, Cleanup, confirm evidence survived. Cleanup after every failed iteration too. Fix what fails. Never-executed is a draft, not a deliverable. If proved in a stand-in, list what the stand-in did that the target will not.

## 5. Promotion & Maintenance

- Once `deterministic` and repeatedly passing, promote into a native spec (for example, `tests/e2e/<feature>.spec.ts`).
- Update status to `graduated-to-e2e` and delegate driving to that test command.
- Point the user to `maintain-verification-skill` for upkeep.
