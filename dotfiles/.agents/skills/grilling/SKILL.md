---
name: grilling
description: "Interviews the user to resolve design decisions before coding. Covers the whole design in rounds, finds facts itself, and decides anything with a clear best answer. Use when requirements are fuzzy, before coding, or says grill me."
---

# Grilling

Interview the user to resolve design decisions before writing code. Cover the whole design, ask in rounds, and decide as much as you can yourself.

## What to resolve

- List every decision the work needs.
- Some decisions depend on others. Ask the ones you can ask now, then the ones they unlock.
- Cover the whole list. Give every decision an answer.

## Who decides

Each decision is one of three kinds.

- **A fact.** If reading the code, running something, or searching can answer it, find it yourself. Never ask the user for something you can look up. If the answer depends on something still running, ask the other questions now and come back to it.
- **A call with a clear best answer.** Decide it. Say what you chose and why, so the user can change it.
- **A real preference, a product call, or something hard to undo.** Ask the user. Only this kind waits on a person.

The user can take over any decision and answer it themselves.

## Rounds

- Ask in rounds. A round is every open question you can ask now, without guessing at answers you have not heard yet.
- Ask the whole round at once. Number each question, give your recommended answer, and list what you decided on your own so the user can change it.
- Wait for the answers, then ask the next round.
- Keep going until every decision has an answer or a default you noted down. Do not write code until the user confirms the plan.

## Output

- End with an agreed plan in 5 lines or fewer.
- Name the finish line: the observable condition that means the work is done.
- Name the stop points: the decisions only the user can make, and anything destructive. The agent keeps going through everything else.
- Sequence implementation into small, verifiable units (each ending in an executable check or red-to-green proof), rather than a single batch edit.
- State the agreed decisions in the commit message that lands the work.
