---
name: which-skill
description: Find the right skill for your task. A simple index of installed skills. Use when no other skill clearly matches the task.
---

# Which Skill

Pick a skill for the work. Specs and tickets for a project live under that project's `.scratch/`. The skills that write them already know that path.

Main path (idea to shipped code):

1. Clarify with `/grill-with-docs` (writes `CONTEXT.md` and ADRs). Use `/grill-me` if there is no codebase yet.
2. Optional: if a design needs a quick proof, `/handoff`, then `/prototype` in a new chat, then `/handoff` back.
3. Large work: `/to-spec` → `.scratch/<feature>/spec.md`, then `/to-tickets` → `.scratch/<feature>/issues/`, then `/implement` one unblocked ticket per fresh chat. Small work: `/implement` in this chat.
4. `/implement` uses `/tdd` and `/code-review` before commit.

Keep steps 1–3 in one chat when you can. If the chat is too full, `/handoff` and continue elsewhere.

Other starting points:

- Hard bugs → `/diagnosing-bugs` (one repro command or test, then fix)
- Huge unclear work → `/wayfinder` under `.scratch/<effort>/`, then `/to-spec`
- Cleanup → `/improve-codebase-architecture` (scan, report, then grill through the pick)
- Terms / ADRs → `/domain-modeling`
- Module shape → `/codebase-design`
- The interview, no docs → `/grilling`
- Save context → `/handoff`
- Summarize in place → `/compact`
- No codebase yet → `/grill-me` (writes nothing)
- Throwaway UI/logic check → `/prototype`
- Deep docs dig → `/research`
- Edit skills or `AGENTS.md` → `/writing-for-agents`
