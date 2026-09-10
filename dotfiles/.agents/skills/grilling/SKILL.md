---
name: grilling
description: "Interviews the user to lock design decisions. Use when requirements are fuzzy, the user wants to plan before coding, or says grill me. Skip when the plan is already approved."
---

# Grilling

Interview the user to resolve the most important architectural and implementation decisions before writing code.

## Rules

- List the required design decisions and their dependencies. Rank the list by importance.
- Ask one round of questions. Start at the top of the ranked list and keep it to a handful.
- Include a recommended answer with every question.
- Check the codebase and documentation first. Ask about the gaps you find there.
- Do not write implementation code until the user approves the final plan.

## Documentation

- Record project terms in `docs/CONTEXT.md` as they are defined.
- Record significant, irreversible architectural decisions in `docs/adrs/NNNN-<title>.md`.

## Output

- End the session with an agreed plan in 5 lines or fewer.
- Sequence implementation into small, verifiable units (each ending in an executable check or red-to-green proof), rather than a single batch edit.
- List any created or updated files under `docs/`.
