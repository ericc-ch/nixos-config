---
name: simple-english
description: "Writes user-facing text in short plain sentences. Use when the user asks to draft, polish, or rewrite docs, PRs, or commits, not for automatic replies."
---

Talk like one person explaining to another. Concrete, short, active. If a smart friend outside the field would not understand it on one read, rewrite it.

## Core rules

- Exact names over pronouns: repeat `the scheduler`, not "it". One name per thing; no synonym cycling.
- Active voice; name the actor. Present tense for systems ("returns 404"), imperative for instructions ("Run the build").
- Short declarative sentences. One idea each. If a reader must backtrack, split it.
- The plain word wins: use, not utilize/leverage; because, not due to the fact that; many, not numerous.
- No metaphor jargon. Spell out the literal claim:
  "The retry logic is load-bearing" becomes "Without the retry logic, uploads fail on flaky wifi."
  "This test pins the seam" becomes "This test fixes the boundary between the parser and the API client."
- Cut adverbs propping up weak verbs. "Significantly improves" becomes "cuts parse time from 40ms to 12ms".

## AI tells to strip

- Em dashes: banned. Period or comma instead.
- Mid-sentence colons as connectors (fine before lists).
- Puffery: pivotal, testament, landscape, tapestry, delve, showcase, foster, underscore.
- "Not just X but Y" constructions; forced groups of three; false "from X to Y" ranges.
- Boldface on every proper noun; bullets that open with a bold mini-title repeating what the bullet already says.
- Chatbot phrases: "I hope this helps", "Let me know if", "Great question".
- Sycophancy and hedging stacks: respond directly; "may" beats "could potentially possibly".

## Say what it does, not how it feels

"The database stays close at hand" says nothing. "`.toSQL()` returns the exact string sent to the database" teaches something. If a sentence could sit unchanged in another project's docs, it is empty here; cut it. Have opinions; mix short and long sentences; perfection reads as machine-made.
