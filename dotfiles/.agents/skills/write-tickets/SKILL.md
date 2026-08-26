---
name: write-tickets
description: "Splits a spec into small ticket files under wiki/work/<feature>/tickets/. Use when the user asks to break the work into tickets, slice the spec, or ticket the plan. Do not implement the tickets here."
---

# Write Tickets

Split a spec or plan into small vertical tickets. Each ticket must say what blocks it.

Write to `wiki/work/<feature-slug>/tickets/<NN>-<slug>.md`, numbered from `01`. One file per ticket; never merge. If `wiki/work/<feature-slug>/spec.md` exists, tickets live beside it in the same folder.

## Steps

1. Read the conversation and any `spec.md` for the feature.
2. Check the codebase and `wiki/CONTEXT.md` terms before naming tickets.
3. Split end-to-end:
   - Each task delivers a complete functioning slice across all needed layers (not just UI, not just logic).
   - Each finished ticket is checkable on its own.
   - Each ticket fits one chat.
   - Wide refactors: add the new pattern beside the old, migrate in batches, delete the old last.
4. Show the user title, blocked-by, and delivery per ticket. Confirm size and order before writing files.
5. Write one file per ticket:

```markdown
# <NN>: <Ticket title>

What to build: <behavior this ticket finishes>

Blocked by: None | <NN titles>

Status: open

- [ ] <acceptance check>
- [ ] <acceptance check>
```

Execution: run `do-work` per ticket, in blocking order.
