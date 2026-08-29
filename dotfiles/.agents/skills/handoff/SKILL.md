---
name: handoff
description: "Writes a short continuation note so the next chat can resume. Use when the user is stopping, context is full, or they ask to save progress. Do not dump the transcript."
---

# Handoff

Write a concise continuation doc for a fresh session, then point the next session at it (or let `work` session-pickup find it).

## Rules

1. **Location:** `wiki/works/<name>/session.md`. Create the folder if needed.
2. **Point, do not copy.** Reference existing specs, tickets, commit SHAs; never duplicate their content.
3. **No secrets.** No API keys, credentials, private data.

## Shape

```markdown
# Session: <topic> (<date>)

State: <where things stand in 3 lines>

Done:
- <shipped, with SHAs>

In flight:
- <partial work, exact resume point: file, branch, failing command>

Next:
1. <step>
2. <step>

Decisions made:
- <choice and why, one line each — prevents re-litigating>

Gotchas:
- <sharp edges the next agent will hit>

Suggested skills: work (playbook: <x>), tdd, review
```

Keep it under 60 lines. A note that restates everything is a transcript, not a handoff.
