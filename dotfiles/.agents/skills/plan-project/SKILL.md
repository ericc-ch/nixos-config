---
name: plan-project
description: "Tracks one open planning question at a time in wiki/work/<effort>/map.md. Use for work that will span many sessions, or when the user asks to plan a large project. Do not build features while wayfinding."
---

# Plan Project

For efforts larger than one session: decide questions one at a time in the current project. Do not build features while wayfinding.

Paths (create folders as needed):

- Map: `wiki/work/<effort>/map.md`
- Ticket: `wiki/work/<effort>/tickets/<NN>-<slug>.md`, written only when its decision is done

One open question at a time; no parallel tickets.

## Rules

1. Each decision answers exactly one question. No feature code.
2. One decision per chat unless the user wants to continue.
3. Refer to decisions by title, not only number.
4. Nothing left to decide? Run `write-spec` on the map.

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

Type: research | prototype | interview | task

Question: <the decision>

Answer: <the decided answer>
```

Types: `research` (look up facts), `prototype` (throwaway sample via the `do-work` prototype playbook), `interview` (via `clarify-plan`), `task` (manual setup: keys, data, access).

## Flow

1. Agree the Destination through `clarify-plan`.
2. Write `map.md` with empty Decisions so far.
3. Pick the next question and settle it in chat (research / prototype / interview / task).
4. Write its ticket once decided; link it under Decisions so far; update Not yet specified.
5. Repeat until nothing is left, then `write-spec`.
