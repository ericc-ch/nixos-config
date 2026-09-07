---
name: create-verification-skill
description: "Generates a project-local verification skill that drives the real app the way a user does. Use for /create-verification-skill, 'make a verify harness', or when a repo has no scripted way to prove UI/CLI/API behavior. Skip when a working verify skill already exists."
---

# Create a Verification Skill

Every serious project needs a scripted way to drive the real app and prove behavior: launch it, exercise a feature the way a user would, and capture evidence. This skill generates a project-local skill (`.agents/skills/verify-<app>/`) tailored to the repo. Write the output for the next agent, not a human: it will be read cold, mid-task, by an agent that has never seen the app.

## 1. Interview the repository

Inspect the codebase directly. Only ask the user what you cannot observe:

- Surface: What does a user interact with? Web UI, CLI, desktop app, API, or library? Pick the primary surface.
- Run: How does the app start locally? Check package scripts, Makefile, Docker, or README. Note ports, environment variables, seed data, and auth.
- Drive: How can an agent drive the app programmatically? Look for existing harnesses first (Playwright specs, expect scripts, curl commands). If none exist, choose a tool: headless browser for web, tmux or PTY for CLI, HTTP requests for services.
- Observe: What evidence proves behavior? Capture screenshots, terminal transcripts, response bodies, exit codes, and database state.
- Isolate: Can multiple instances run side by side without corrupting user state? If not, state that multiple instances cannot run at once.

If the project does not build or start as-is, fix that first before generating. A skill written against a broken base teaches wrong steps.

## 2. Generate the skill

Write `.agents/skills/verify-<app>/SKILL.md` with YAML frontmatter (`name: verify-<app>` and a clear `description`). Include these sections:

- Launch: The exact command that starts the app for verification. State how to tell the app is ready (log line, port answering, prompt). Save process IDs for cleanup.
- Doctor: One read-only check that answers "is this instance ready to test?" (process up, port owned by us, auth valid). Run this check before driving.
- Drive: The harness instructions using real selectors and commands from this repository, not placeholders. Prefer stable handles (ARIA labels, data attributes, route paths).
- Evidence: What to capture for proof and where to store it (for example, `.audit/evidence/`). Exercise the real user path. Verify side effects like written files and inserted database rows.
- Cleanup: How to stop instances created during the run. Never kill by broad process name. Kill only what was started. Evidence must survive cleanup.
- Helpers: Make all helper scripts executable and document their usage in the skill body.

## 3. Seed the feature map

Create `.agents/skills/verify-<app>/features/README.md` and one file per primary user-facing feature (top 3–5 to start).
Each feature file must use these four H2 sections:
- `## Sub-features`
- `## How to get to it (user POV)`
- `## Driving it with <harness>`
- `## Gotchas`

## 4. Prove the generated skill

Before handing over to the user, run its own instructions end-to-end once:
1. Run `Launch`.
2. Run `Doctor`.
3. Drive ONE mapped feature.
4. Capture evidence to the named location.
5. Run `Cleanup`.
6. Confirm the evidence artifact survived cleanup.

Fix what fails. A verification skill that was never executed is a draft, not a deliverable.

## 5. Maintenance

Point the user to `maintain-verification-skill` for keeping the feature map and harness honest as the application evolves.
