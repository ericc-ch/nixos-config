---
name: writing-for-agents
description: "Writes the documents an agent reads: skills, AGENTS.md, CLAUDE.md, and notes reached by a pointer. Use when creating or editing a skill or an agent instruction file."
---

# Writing for agents

Write for an agent that reads the document cold, mid-task, with none of your context. The agent takes the same process every run. These rules make each run predictable.

## Pointers

A pointer is a line that names material living somewhere else and gives the condition for reaching it. A skill description is a pointer. A line in an instruction file naming a doc is the same thing.

The wording of the pointer decides whether the material gets reached. A must-have file behind a weak pointer is a bug. Sharpen the wording first. Inline the material only if sharpening fails.

A pointer does two jobs: it says what the material is, and it lists the cases that should trigger reaching for it. Keep it short, because every word of a pointer costs on every run.

- Front-load the word that does the triggering.
- One trigger per case. Words that rename the same case are one case written twice.
- Cut anything the target already says.

## Two costs

Every file and pointer spends one of two budgets.

- **Always-loaded cost:** material in context on every run, whether or not it fires. Skill descriptions and instruction files sit here.
- **Memory cost:** what the reader must remember. Which files exist and when to reach for each. Only the reader knows which files exist. This is not a cost to remove. Spend it where judgement matters.

## Three levels

Place each piece of content at one of three levels.

1. **A step in the file:** what the agent does, in order.
2. **Reference in the file:** rules and facts consulted on demand.
3. **Reference behind a pointer:** pushed to another file, loaded only when the pointer fires.

Push down what only some paths need. Keep in the main file what every path needs. When the top of a document gets buried, move reference down a level instead of trimming words from it.

## Steps need a clear finish

Every step ends on a condition that says it is done. A vague condition invites the agent to rush. The condition should be both checkable and demanding. "Every changed model accounted for" forces real work. "Produce a list" does not.

## Use a word the model already knows

A short, common word that names a concept the model already holds anchors behavior in few tokens. "A tight loop." "Go red." Reach for an existing word before inventing one. A new word pays for its definition and buys nothing.

## Say the target, not the ban

Naming what not to do drags it into context and makes it more likely. State the behavior you want. "Write one-line comments" beats "do not write long comments." Keep a ban only when you cannot phrase the target, and pair it with the positive form.

## One meaning, one place

Keep each meaning in a single spot, so changing behavior is a one-place edit. Repetition inflates a meaning past its real importance.

Check each line against what the document does. Delete sentences that change nothing versus the default. The test is whether the line changes behavior, not whether a reader agrees with it.

The default failure is stale layers piling up, because adding feels safe and removing feels risky. Prune on every pass.
