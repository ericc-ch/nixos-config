---
name: wayfinder
description: Plan large projects by deciding one question at a time and writing answers under .scratch/.
disable-model-invocation: true
---

# Wayfinder

Use this when a project is too big for one chat. Decide questions one at a time in the **current project**. Do not build features while wayfinding.

Paths (create folders if needed):

- Map: `.scratch/<effort>/map.md`
- Ticket: `.scratch/<effort>/issues/<NN>-<slug>.md` (from `01`) — **only write this file when the decision is done**

Do not use GitHub Issues. No setup step. No parallel tickets; one open question at a time.

Rules:

1. Each decision answers one question. Do not write feature code.
2. Finish one decision per chat (or keep going only if the user wants to continue).
3. Refer to decisions by title, not only by number.
4. When the map has nothing left to decide, run `/to-spec`.

Write the map first (after Destination is agreed):

```markdown
# <Effort name>

Destination: <what done looks like, 1-2 lines>

Notes: <skills, repo rules, preferences>

Decisions so far:
- [Ticket title](./issues/01-slug.md) — <gist>

Not yet specified:
- <question not ready to decide>

Out of scope:
- <excluded idea>
```

Keep open work on the map only (Not yet specified, or the next question in chat). Do not create empty ticket files ahead of time.

When a decision is finished, write its ticket once:

```markdown
# <NN> — <Ticket title>

Type: research | prototype | grilling | task

Question: <the decision>

Answer: <the decided answer>
```

Types:

- `research` — look up facts in docs, APIs, or code
- `prototype` — throwaway sample with `/prototype`
- `grilling` — interview with `/grilling`
- `task` — manual setup before a decision (keys, data, access)

Flow:

1. Agree on Destination with `/grilling`.
2. Write `map.md` with Notes, empty Decisions so far, Not yet specified, Out of scope.
3. Pick the next question. Decide it in chat (research / prototype / grilling / task).
4. Write the ticket file with Question + Answer. Link it under Decisions so far. Update Not yet specified.
5. Repeat until nothing is left to decide, then `/to-spec`.
