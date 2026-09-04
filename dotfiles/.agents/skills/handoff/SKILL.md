---
name: handoff
description: "Writes a continuation note to docs/HANDOFF.md. Use when the user stops, context runs full, or the user asks to save progress."
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
