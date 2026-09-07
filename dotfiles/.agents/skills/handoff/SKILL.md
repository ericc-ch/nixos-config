---
name: handoff
description: "Writes a continuation note to docs/HANDOFF.md. Use when the user stops, says wrap up, pause, context runs full, or asks to save progress. Skip during active ongoing iteration."
---

# Handoff

Write a continuation note for a fresh session to `docs/HANDOFF.md` in the repository. Keep one file and update it in place.

## Rules

1. Reference existing documents, commit SHAs, and open files. Do not copy their contents into the note.
2. Require evidence for completed items. Every item listed under `Done` must cite its commit SHA and its verification proof (test run, command output, or screenshot). Leave unproven work under `In flight`.
3. Do not include secrets, API keys, credentials, or private data.
4. Keep the note under 60 lines.

## Shape

```markdown
# Handoff (<date>)

State: <where things stand in 3 lines; note if repo-local verification/doctor check is green>

Done:

- <shipped, with SHA and verification evidence/artifact>

In flight:

- <partial work, exact resume point: file, branch, failing command or unverified state>

Next:

1. <step>
2. <step>

Decisions made:

- <choice and why, one line each>

Gotchas:

- <sharp edges the next agent will hit>
```
