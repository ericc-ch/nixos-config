---
name: wayfinder
description: Plan large or complex projects by creating decision tickets on your issue tracker and resolving them one by one.
disable-model-invocation: true
---

# Wayfinder

Plan large or complex projects that are too big for a single chat window. Create a master map issue on your issue tracker and resolve individual decision tickets one at a time until the project plan is clear.

Verify that `/setup-matt-pocock-skills` was run to configure your issue tracker settings.

## Core Rules

1. **Decide, do not build:** Each ticket resolves a decision or answers a question. Do not write feature code during wayfinding.
2. **One ticket per session:** Resolve only one decision ticket per chat window.
3. **Use names:** Always refer to tickets by their title, not just an issue ID number.
4. **Hand off when finished:** When all decision tickets are resolved, run `/to-spec` to begin building.

---

## The Master Map

Create a parent issue on your issue tracker labeled `wayfinder:map`.

```markdown
## Target Outcome
Describe what reaching the end of this project looks like in 1-2 lines.

## Project Notes
Skills to use, repo rules, or domain constraints.

## Decisions Made
- [Ticket Title](link) — One-line summary of the decided answer.

## Not Yet Specified
Future questions that cannot be turned into tickets yet because prerequisite decisions are still open.

## Out of Scope
Ideas or features explicitly excluded from this project effort.
```

---

## Decision Ticket Types

Each child ticket represents one decision or investigation. Tag each ticket with one type:

- **Research:** Search docs, APIs, or external resources for missing facts.
- **Prototype:** Build a quick throwaway sample (using `/prototype`) to test a UI layout or state logic.
- **Interview:** Use `/grilling` to ask the user questions and decide a design choice.
- **Task:** Perform manual setup (such as creating API keys or preparing test data) required before a decision can be made.

---

## Workflow Steps

### 1. Create the Master Map
1. **Define the Target Outcome:** Run `/grilling` to agree on what finishing this project looks like.
2. **Identify initial decisions:** List open questions and immediate next steps.
3. **Create the parent map issue:** Label it `wayfinder:map`.
4. **Create child tickets:** Create tickets for questions you can answer now, and link dependencies. Put remaining unknown questions under **Not Yet Specified**.

### 2. Work Through Tickets
1. **Select a ticket:** Pick an unblocked ticket from the map.
2. **Resolve the decision:** Perform the research, prototype, interview, or setup task.
3. **Save the result:** Post the decision answer as a comment, close the ticket, and add a link to **Decisions Made** on the master map.
4. **Update the map:** Turn any newly clear questions from **Not Yet Specified** into new decision tickets.
5. **Finish:** When all tickets are resolved, hand off to `/to-spec`.
