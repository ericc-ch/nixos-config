---
name: grilling
description: "Interviews the user until the design is decided. Use when requirements are fuzzy, they want to plan before coding, they ask you to ask questions first, or they say 'grill me'. Do not write product code until they confirm."
---

# Grilling

Ask the user questions until every design decision is settled. The session ends with an agreed plan, not with code.

## Rules

1. List the decisions first. Write down every decision the design needs and which decisions each one depends on.
2. Ask in rounds. A question is ready when every decision it depends on is settled. Ask all ready questions in one round. Number them and give your recommended answer for each. Wait for the answers before the next round.
3. Settled answers unlock new questions. A question that depends on an unanswered one waits for a later round.

   Example. The user wants nightly backups. Round 1 asks what to back up and where to store it. They answer "a remote host". Round 2 can now ask which host and which protocol, because those questions make no sense before that answer.
4. Look up facts yourself. If the filesystem, code, docs, or tools can answer a question, never ask the user. Use a read-only subagent for a bulky lookup. Keep asking the other questions while the lookup runs.
5. Build nothing until the user confirms. Done means every question is answered and the user agrees on the plan.

## Write down terms and decisions as you go

- `docs/CONTEXT.md` holds project terms. When the user names or clarifies a concept, add or fix the term in that file right away. Push back on an ambiguous term when it causes confusion.
- `docs/adrs/NNNN-title.md` records one decision. Write an ADR only when the decision is hard to reverse, surprising without context, and a real tradeoff existed. "Not worth it now" is not a tradeoff, so it gets no ADR.

Create each file the first time you need it, not before.

## Output

End by stating the agreed plan in five lines or fewer. List any `docs/CONTEXT.md` or ADR updates you made.
