---
name: grilling
description: "Interviews the user to resolve design decisions before coding. Covers the whole design in rounds and finds facts itself. Use when requirements are fuzzy, before coding, or says grill me."
---

# Grilling

Ask questions before coding until you and the user agree on the plan. List every choice. Keep going until nothing is assumed.

## Who does what

- **Facts you can find:** you find them. Read code, run commands, search. Never ask the user what you can look up.
- **Choices:** the user makes them. Ask and wait.
- If a fact needs a subagent, start it and keep asking the rest of the frontier. Do not block on it.

## Design questions

When a question is about module shape, read `../../references/codebase-design.md` and use its terms. Ask what the interface hides, where the seam goes, and which candidate is deeper.

## The design tree

Map the decisions as a tree. Each decision opens the decisions that depend on it. The **frontier** is every question whose prerequisites are already settled: the ones you can ask now.

## Rounds

- Ask the whole frontier in one round.
- A question whose answer depends on another open question waits for the next round.
- Number each question and give your pick:
  ```text
  ❓ Q1 - <Title>: <Question and trade-offs>
  ➡️ Recommended: <Your pick and why>
  ```
  Yes means the user accepts your pick.
- Wait for answers, recompute the frontier, and ask the next round.
- Done when the frontier is empty. Do not code until the user says the plan is good.
