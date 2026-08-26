---
name: Map
description: Plan a project too big for one chat by deciding one question at a time, tracked in wiki/work/<effort>/map.md. Use for "plan this project", multi-week efforts, or work spanning many sessions.
metadata:
  opencode/autoinvoke: false
---

# Map

For efforts larger than one session: decide questions one at a time in the current project. Do not build features while wayfinding.

Paths (create folders as needed):

- Map: `wiki/work/<effort>/map.md`
- Ticket: `wiki/work/<effort>/tickets/<NN>-<slug>.md`, written only when its decision is done

One open question at a time; no parallel tickets.

## Rules

1. Each decision answers exactly one question. No feature code.
2. One decision per chat unless the user wants to continue.
3. Refer to decisions by title, not only number.
4. Nothing left to decide? Run `spec` on the map.

## Map file

```markdown
# <Effort name>

Destination: <what done looks like, 1-2 lines>

Notes: <skills, repo rules, preferences>

Decisions so far:

- [Ticket title](./tickets/01-slug.md): <gist>

Not yet specified:

- <question not ready to decide>

Out of scope:

- <excluded idea>
```

Keep open work on the map only. Never pre-create empty ticket files.

## Decision ticket

```markdown
# <NN>: <Ticket title>

Type: research | prototype | grilling | task

Question: <the decision>

Answer: <the decided answer>
```

Types: `research` (look up facts), `prototype` (throwaway sample via the prototype playbook), `grilling` (interview via grill), `task` (manual setup: keys, data, access).

## Flow

1. Agree the Destination through `grill`.
2. Write `map.md` with empty Decisions so far.
3. Pick the next question and settle it in chat (research / prototype / grilling / task).
4. Write its ticket once decided; link it under Decisions so far; update Not yet specified.
5. Repeat until nothing is left, then `spec`.
