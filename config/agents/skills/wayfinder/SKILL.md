---
name: wayfinder
description: Plan large projects as decision tickets in .scratch/, one ticket per chat.
disable-model-invocation: true
---

# Wayfinder

Use this when a project is too big for one chat. Chart decisions as markdown in the **current project**. Do not build features while wayfinding.

Paths (create folders if needed):

- Map: `.scratch/<effort>/map.md`
- Ticket: `.scratch/<effort>/issues/<NN>-<slug>.md` (from `01`)

Do not use GitHub Issues. No setup step.

Rules:

1. Each ticket answers one question. Do not write feature code.
2. Resolve one ticket per chat.
3. Refer to tickets by title, not only by number.
4. When every ticket is resolved, run `/to-spec`.

Write the map like this:

```markdown
# <Effort name>

Destination: <what done looks like, 1-2 lines>

Notes: <skills, repo rules, preferences>

Decisions so far:
- [Ticket title](./issues/01-slug.md) — <gist>

Not yet specified:
- <question that cannot be a ticket yet>

Out of scope:
- <excluded idea>
```

Each ticket file:

```markdown
# <NN> — <Ticket title>

Type: research | prototype | grilling | task
Status: open | claimed | resolved
Blocked by: None | 01, 02

Question: <the decision to make>

Answer: <fill when resolved>
```

Types:

- `research` — look up facts in docs, APIs, or code
- `prototype` — throwaway sample with `/prototype`
- `grilling` — interview with `/grilling`
- `task` — manual setup before a decision (keys, data, access)

Create the map:

1. Agree on Destination with `/grilling`.
2. List open questions.
3. Write `map.md` and tickets for questions you can ask now.
4. Leave the rest under Not yet specified.

Work tickets:

1. Pick the lowest-number ticket that is not `resolved` and has no unresolved blockers.
2. Set `Status: claimed`.
3. Do the research, prototype, grilling, or task.
4. Fill Answer, set `Status: resolved`.
5. Add a gist + link under Decisions so far in `map.md`.
6. Promote new clear questions from Not yet specified into tickets.
7. When nothing is left to decide, run `/to-spec`.
