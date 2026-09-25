---
name: handoff
description: "Writes a continuation note to docs/HANDOFF.md. Use when the user stops, says wrap up, pause, context runs full, or asks to save progress. Skip during active ongoing iteration."
---

# Handoff

Write a continuation note for a fresh session to `docs/HANDOFF.md` in the repository. Keep one file and update it in place.

## Rules

1. State the high-level goal and plan at the top to give context for the work.
2. Reference existing documents, commit SHAs, and open files. Do not copy their contents into the note.
3. Require evidence for completed items. Every item listed under `Done` must cite its commit SHA and its verification proof (test run, command output, or screenshot). Leave unproven work under `Unfinished`.
4. Do not include secrets, API keys, credentials, or private data.
5. For long or unattended work, keep a running task list in a file and update it as you go. Point the note at that file instead of copying it.

## Shape

```markdown
# Handoff (<date>)

Goal: <what you want to achieve and why>

Plan: <high-level plan to reach the goal>

State: <where things stand, plus whether the repo-local verification or doctor check is green>

Done:

- <shipped, with SHA and verification evidence/artifact>

Unfinished:

- <partial work, exact resume point: file, branch, failing command or unverified state>

Next:

1. <step>
2. <step>

Decisions made:

- <choice and why>

Gotchas:

- <problems the next agent will run into>
```
