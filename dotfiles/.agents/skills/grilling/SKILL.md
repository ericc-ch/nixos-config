---
name: grilling
description: "Interviews the user to lock design decisions. Use when requirements are fuzzy, the user wants to plan before coding, or says grill me. Skip when the plan is already approved."
---

# Grilling

Interview the user to resolve the most important architectural and implementation decisions before writing code.

## Rules

- List the required design decisions and their dependencies. Rank the list by importance.
- Ask one round of questions. Start at the top of the ranked list and keep it to three to five questions.
- Include a recommended answer with every question.
- Check the codebase and documentation first. Ask about the gaps you find there.
- Do not write implementation code until the user approves the final plan.

## Output

- End the session with an agreed plan in 5 lines or fewer.
- Sequence implementation into small, verifiable units (each ending in an executable check or red-to-green proof), rather than a single batch edit.
- State the agreed decisions in the commit message that lands the work.
