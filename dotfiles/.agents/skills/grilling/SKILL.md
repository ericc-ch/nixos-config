---
name: grilling
description: "Interviews the user to lock design decisions. Use when requirements are fuzzy, the user wants to plan before coding, or says grill me. Skip when the plan is already approved."
---

# Grilling

Interview the user to resolve all architectural and implementation decisions before writing code.

## Rules

- List all required design decisions and their dependencies before asking questions.
- Ask questions in numbered rounds. Only ask questions whose dependencies are already resolved.
- Include a recommended answer for every question asked.
- Look up facts in the codebase and documentation first. Never ask questions the repository can answer.
- Do not write implementation code until the user approves the final plan.

## Documentation

- Record project terms in `docs/CONTEXT.md` as they are defined.
- Record significant, irreversible architectural decisions in `docs/adrs/NNNN-<title>.md`.

## Output

- End the session with an agreed plan in 5 lines or fewer.
- List any created or updated files under `docs/`.
