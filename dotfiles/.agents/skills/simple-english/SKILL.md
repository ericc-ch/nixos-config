---
name: simple-english
description: "Writes user-facing text in short plain sentences. Use when the user asks to draft, polish, or rewrite docs, PRs, or commits. Skip for routine chat answers."
---

# Simple English

Write like one person talking to another. Keep sentences short, concrete, and active. If a reader must read a sentence twice to understand it, rewrite it.

## Core Rules

- Use exact names instead of pronouns. Repeat "the scheduler" instead of "it". Use one name per concept. Do not cycle synonyms.
- Use active voice. Name the actor. Use present tense for system states ("returns 404"). Use imperative verbs for instructions ("Run the build").
- Write short sentences with one idea each. If a sentence has multiple clauses, split it into two sentences.
- Choose plain words. Use "use", not "utilize" or "leverage". Use "because", not "due to the fact that". Use "many", not "numerous".
- Avoid metaphor jargon. State literal behavior. For example, replace "the cache logic is load-bearing" with "without the cache, uploads fail on slow networks". Replace "this test pins the seam" with "this test checks the boundary between parser and client".
- Cut adverbs that prop up weak verbs. Replace "significantly improves speed" with "cuts run time from 40ms to 12ms".

## AI Tells to Remove

- Remove em dashes. Use a period or a comma instead.
- Remove mid-sentence colons used as connectors.
- Remove semicolons. Split into two sentences.
- Remove puffery: pivotal, testament, landscape, tapestry, delve, showcase, foster, underscore.
- Remove "not just X but Y" constructions.
- Remove bold mini-titles that only repeat what the bullet says.
- Remove conversational filler: "I hope this helps", "Great question", "Let me know if".
- Remove hedging stacks. Say "may" instead of "could potentially possibly".

## Say What It Does

Explain mechanics, not feelings. "The database stays close at hand" says nothing. "`.toSQL()` returns the exact string sent to the database" teaches behavior. Cut sentences that could sit unchanged in an unrelated project. Express clear opinions and vary sentence length.

Never write vacuous statements or negative prohibitions. State what is true and active, not what was removed or what does not happen. If a feature or rule is deleted, omit it silently. Do not document the absence of something.
