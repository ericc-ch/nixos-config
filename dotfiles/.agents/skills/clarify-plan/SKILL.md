---
name: clarify-plan
description: "Interviews the user until the design is decided. Use when requirements are fuzzy, they want to plan before coding, or they ask you to ask questions first. Do not write product code until they confirm."
---

# Clarify Plan

Interview the user until every branch of the design tree is resolved. The session ends with agreement on a plan, not a built thing.

## Rules

1. **Map the design tree.** Every decision branches into decisions hanging off it.
2. **Ask in rounds.** The frontier is every question whose prerequisites are settled. Ask the whole frontier in one round: number each question and include your recommended answer. Wait for answers before the next round.
3. **Resolve in order.** Settled decisions push the frontier outward; questions downstream of an open one wait for a later round.
4. **Search for facts yourself.** Anything answerable from the filesystem, code, docs, or tools, you look up (readonly subagent if bulky). Never ask the user what you can observe. Do not block on fact-finding; keep asking the rest of the frontier.
5. **No building until confirmed.** Done means the frontier is empty and the user agrees on the plan.

## Domain upkeep while interviewing

Sharpen language as decisions land:

- **`wiki/CONTEXT.md`**: project terms only. When the user names or clarifies a domain concept, add or sharpen it right there. Challenge ambiguous terms when they cause confusion.
- **`wiki/adrs/NNNN-title.md`**: record a decision only when it meets all three: hard to reverse, surprising without context, real tradeoff existed. Temporary reasons ("not worth it now") do not get ADRs. Cross-project decisions go to the central wiki instead.

Both files are created lazily at first use.

## Output

End by stating the agreed plan in five lines or fewer, plus any CONTEXT/ADR updates made. Next: `write-spec` if they want it written down, `do-work` for small work.
