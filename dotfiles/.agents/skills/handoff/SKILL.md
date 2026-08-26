---
name: handoff
description: Save a summary of this chat so a fresh session can continue the work. Use at session end, before context runs out, or when the user says "handoff" or "save state".
---

# Handoff

Write a concise continuation doc for a fresh session, then point the next session at it (or let `swe` session-pickup find it).

## Rules

1. **Location:** `/tmp/handoff-<topic>.md`; use `wiki/work/<name>/handoff.md` when it belongs to tracked work and must survive reboots.
2. **Point, do not copy.** Reference existing specs, tickets, commit SHAs; never duplicate their content.
3. **No secrets.** No API keys, credentials, private data.

## Shape

```markdown
# Handoff: <topic> (<date>)

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

Suggested skills: swe (playbook: <x>), tdd, review
```

Keep it under 60 lines. A handoff that restates everything is a transcript, not a handoff.
