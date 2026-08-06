---
name: writing-for-agents
description: Writing documents agents read. Use when creating or editing skills, or modifying AGENTS.md.
---

Write documents an agent will read and follow: skills, `AGENTS.md`, docs reached from a pointer. The packaging differs; the writing does not.

## The description is the trigger

A skill's `description` (or the `AGENTS.md` line naming a doc) decides when the agent reaches the material. Sharpen the wording before you lengthen the material.

- Front-load the leading word — the phrase that names the work.
- One trigger per branch. "Diagnose", "debug", and "fix a crash" are one branch written three times; keep one.
- Say what the doc is for, not what it contains.

## Two loads

Everything you add spends one of two budgets:

- **Context load** — always-loaded material: skill descriptions, `AGENTS.md` lines. Costs tokens on every turn whether it fires or not.
- **Cognitive load** — what the human must remember: which documents exist, when to reach for each. The human is the index.

Material reached through a pointer avoids context load at the price of one line. Material with no pointer rides entirely on the human's memory.

## Where material lives

The ladder, ranked by how immediately the agent needs it:

1. **In-file steps** — what the agent does, in order. The primary tier.
2. **In-file reference** — rules and facts consulted on demand.
3. **Disclosed reference** — pushed to a separate file, reached by a pointer, loaded only when the pointer fires.

Inline what every run needs; push behind a pointer what only some runs reach. Push too little down and the top bloats; push too much and the agent misses material it needs.

## Steps and completion criteria

Each step ends on a **completion criterion** — the condition that tells the agent the work is done. Two properties matter:

- **Clarity** — can the agent tell done from not-done? A vague bound ("understanding reached") invites the agent to call it done early.
- **Demand** — how much it requires. "Every modified module accounted for" forces thorough work; "produce a change list" does not.

Sharpen the bound first; only hide later steps from view when the agent still rushes ahead of the work.

## Leading words

Reuse a word the model already knows well — _lesson_, _tracer bullet_ — to anchor a whole behavior in few tokens. Repeat the word; never restate the idea. A made-up word recruits nothing and costs you its definition.

Steer with the **positive**: say what to do ("write one-line comments"), not what to avoid. Prohibitions drag the forbidden behavior into context and make it more likely.

## Pruning

- Keep one meaning in one place. Duplication costs maintenance and tokens.
- The environment is a source of truth. `package.json` scripts, config files, and `--help` output are lookups — do not restate them. Cache only what the agent cannot find by looking: unwritten conventions, reasons behind choices, gotchas.
- Delete no-ops: instructions the agent obeys anyway. The test is whether the line changes behavior versus the default. When a sentence fails, delete the whole sentence, not the words you like.
- Cut anything stale. Shorter documents stay relevant longer.
