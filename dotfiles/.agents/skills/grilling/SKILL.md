---
name: grilling
description: "Interviews the user to resolve design decisions before coding. Covers the whole design in rounds, finds facts itself, and decides anything with a clear best answer. Use when requirements are fuzzy, before coding, or says grill me."
---

# Grilling

Interview the user to resolve design decisions before writing code. Cover the whole design, ask in rounds, and decide as much as you can yourself.

## What to resolve

- Map decisions as a tree: earlier choices unlock or eliminate later ones.
- Identify the frontier: the set of decisions you can ask *now* without guessing at answers you have not heard yet.
- Cover the whole tree until nothing is left silently assumed.

## Who decides

Each decision is one of three kinds:

- **A fact:** If reading code, running commands, or searching can answer it, find it yourself. Never ask the user for something you can look up. If an investigation is still running, ask the other open questions now and come back to it.
- **A call with a clear best answer:** Decide it. Say what you chose and why, so the user can easily change it.
- **A real preference, a product call, or something hard to undo:** Ask the user. Only this kind waits on a person.

The user can take over any decision and override it.

## Rounds

- Ask in rounds. A round covers the current frontier: every open question that does not depend on unmade choices.
- Number each question and give your recommended answer.
- **Word questions so answering "yes" accepts your recommendation:**
  ```text
  ❓ Q1 - <Title>: <Question text, context, or trade-offs>
  ➡️ Recommended: <Your recommendation and why>
  ```
  This lets the user reply quickly with "yes" or "1: yes, 2: pick option B".
- Wait for the user's answers, update the decision tree, and ask the next round.
- Keep going until the frontier is empty. Do not write code until the user confirms the plan.

## Output

- End with an agreed plan in 5 lines or fewer.
- Name the finish line: the observable condition that means the work is done.
- Name the stop points: the decisions only the user can make, and anything destructive. The agent keeps going through everything else.
- Sequence implementation into small, verifiable units (each ending in an executable check or red-to-green proof), rather than a single batch edit.
- State the agreed decisions in the commit message that lands the work.
