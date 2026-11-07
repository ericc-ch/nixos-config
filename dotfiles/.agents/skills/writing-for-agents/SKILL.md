---
name: writing-for-agents
description: "Writes the documents an agent reads: skills, AGENTS.md, CLAUDE.md, and notes reached by a pointer. Use when creating or editing a skill or an agent instruction file."
---

# Writing for agents

An agent reads the file cold, mid-task, with none of your context. It takes the same steps every run. These rules make that run predictable.

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

Every step ends on a condition that says it is done. A vague condition invites the agent to rush. The condition needs two things.

- **Checkable:** the agent can tell done from not done.
- **Demanding:** it requires real work. "Every changed model accounted for" forces work. "Produce a list" does not.

The steps after the current one pull attention forward. Hide them only across a real context boundary, such as a subagent. In the same window they stay visible.

## Use a word the model already knows

A short, common word that names a concept the model already holds anchors behavior in few tokens. "A tight loop." "Go red." Reach for an existing word before inventing one. A new word pays for its definition and buys nothing.

Look for an idea spelled out at several sites and replace it with one word. "Fast, deterministic, low overhead" becomes "tight". "A loop you believe in" becomes "goes red". Repeat the word. Repeating the meaning is not the point.

## Say the target, not the ban

Naming what not to do drags it into context and makes it more likely. State the behavior you want. "Write one-line comments" beats "do not write long comments." Keep a ban only when you cannot phrase the target, and pair it with the positive form.

## One meaning, one place

Keep each meaning in a single spot, so changing behavior is a one-place edit. Repetition inflates a meaning past its real importance.

Check each line against what the document does. Delete sentences that change nothing versus the default. The test is whether the line changes behavior, not whether a reader agrees with it.

## Use the environment as a source of truth

Do not restate what the agent can look up: package scripts, config files, `--help` output, the directory layout. A copy goes stale. Write down only what a lookup cannot show: an unwritten convention, the reason behind a choice, a gotcha no config admits.

## When to split

Split when one of the two costs buys something.

- **By sequence:** split when later steps tempt the agent to rush the current one. Keep them out of view.
- **By invocation:** a model-invoked skill keeps a description, so the agent and other skills can reach it. A user-invoked skill drops the description and costs nothing per run, but only a human can fire it. Choose user-invoked when only a human fires it.

When user-invoked skills pile up past what you can remember, add a router: one user-invoked skill that names the others and says when to use each.

The default failure is stale layers piling up, because adding feels safe and removing feels risky. Prune on every pass.
