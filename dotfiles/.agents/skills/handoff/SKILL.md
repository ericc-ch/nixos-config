---
name: handoff
description: "Writes a short continuation note to docs/HANDOFF.md so the next chat can resume. Use when the user is stopping, context is full, or they ask to save progress. Do not dump the transcript."
---

Write a concise continuation doc for a fresh session to `docs/HANDOFF.md` in the repo. One file, updated in place each time.

## Rules

1. **Point, do not copy.** Reference existing docs, commit SHAs, and open files; never duplicate their content.
2. **No secrets.** No API keys, credentials, private data.
3. **Under 60 lines.** A note that restates everything is a transcript, not a handoff.

## Shape

```markdown
# Handoff (<date>)

State: <where things stand in 3 lines>

Done:

- <shipped, with SHAs>

In flight:

- <partial work, exact resume point: file, branch, failing command>

Next:

1. <step>
2. <step>

Decisions made:

- <choice and why, one line each>

Gotchas:

- <sharp edges the next agent will hit>
```
