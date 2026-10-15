---
name: grilling
description: "Interviews the user to resolve design decisions before coding. Covers the whole design in rounds and finds facts itself. Use when requirements are fuzzy, before coding, or says grill me."
---

# Grilling

Ask questions before coding until you and the user agree on the plan. List every choice. Keep going until nothing is assumed.

## Who does what

- **Facts you can find:** you find them. Read code, run commands, search. Never ask the user what you can look up.
- **Choices:** the user makes them. Ask and wait.

## Rounds

- Ask in rounds. Each round covers every open question you can ask now.
- Number each question and give your pick:
  ```text
  ❓ Q1 - <Title>: <Question and trade-offs>
  ➡️ Recommended: <Your pick and why>
  ```
  Yes means the user accepts your pick.
- Wait for answers, update the list, and ask the next round.
- Done when no questions are left. Do not code until the user says the plan is good.
