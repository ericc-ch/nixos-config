---
name: to-tickets
description: Split a plan into small end-to-end tickets under .scratch/<feature>/issues/.
---

# To Tickets

Split a spec or plan into small task tickets. Each ticket MUST say what blocks it.

Write files in the **current project**:

`.scratch/<feature-slug>/issues/<NN>-<slug>.md`

Number from `01`. One file per ticket. Never merge tickets into one file. Create folders if needed. Do not use GitHub Issues. No setup step.

If `.scratch/<feature-slug>/spec.md` exists, put issues beside it under the same slug.

Steps:

1. Read the conversation and any `spec.md` for the feature.
2. Check the codebase and domain terms before naming tickets.
3. Split into end-to-end tasks:
   - Each task MUST deliver a full vertical slice (not "UI only").
   - Each finished task MUST be checkable on its own.
   - Each task SHOULD fit one chat.
   - For wide refactors: add the new pattern beside the old one, migrate in batches, then delete the old pattern.
4. Show the user: title, blocked by, what it delivers. Confirm size and order.
5. Write one file per ticket:

```markdown
# <NN> — <Ticket title>

What to build: <behavior this task finishes>

Blocked by: None | <NN titles>

Status: open

- [ ] <acceptance check>
- [ ] <acceptance check>
```
