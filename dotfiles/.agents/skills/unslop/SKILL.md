---
name: unslop
description: "Scans for and removes AI tells, filler, fluff, buzzwords, and mannered prose. Use when polishing, rewriting, or unslopping any text."
---

# Unslop

Edit text to remove machine-written patterns. Scan for the patterns below, rewrite with plain words, and audit what remains.

## Content tells

- **Superficial `-ing` clauses:** "highlighting X", "ensuring Y", "reflecting Z", "fostering community". Delete the clause or state the real mechanism.
- **Vague attributions:** "experts believe", "industry reports suggest", "some critics argue". Name the exact source or cut the claim.
- **Rule of three:** Do not force ideas or examples into groups of three. Use the natural count.
- **False ranges:** "from X to Y" when X and Y do not sit on a shared scale. List items directly instead.
- **Generic conclusions:** "The future looks bright" or "possibilities are endless". State the concrete plan or next step.
- **Fancy ways to say "is":** "serves as", "stands as", "boasts", "features". Write "is" or "has".
- **"Not just X, but Y":** State the real point directly without contrast framing.

## Language tells

- **Puffery:** pivotal, testament, landscape, tapestry, delve, showcase, foster, underscore.
- **AI vocabulary:** additionally, crucial, enduring, enhance, garner, interplay, intricate, vibrant. Replace with plain words.
- **Mannered prose:** Aphorisms ("wire it or delete it"), rhetorical fragments, personified code ("the plan holds it"), and figurative verbs ("rides along", "stands on"). Say what you mean.
- **Synonym cycling:** Calling one concept "the engine", "the processor", and "the core" in the same section. Pick one exact name and repeat it.

## Abstract metaphor nouns

Replace abstract metaphors with concrete words:
- `substrate` -> base, foundation, code
- `wedge` / `wedge in` -> add, insert
- `vector` -> way, method, path
- `locus` / `vantage` / `nexus` -> center, point, place
- `primitive` (as a noun) -> type, helper, function, component
- `harness` (as a metaphor) -> tool, wrapper, runner
- `surface` (as in "API surface") -> API, endpoints, functions
- `bedrock` / `scaffolding` -> base, starter code, structure
- `paradigm` -> pattern, model, approach
- `flywheel` -> feedback loop, self-reinforcing process
- `endgame` -> final phase, goal
- `north star` -> goal, target

## Style tells

- **Dashes:** Remove em dashes (—) and en dashes (–). Use a period or a comma. Do not substitute hyphens for dashes.
- **Colons:** Remove mid-sentence connector colons. Use colons only before a list or a code example.
- **Semicolons:** Remove semicolons. Split into two clean sentences.
- **Quotes:** Replace curly quotes (“ ” ‘ ’) with straight quotes (" ').
- **Emojis:** Remove decorative emojis from headings and bullet points.
- **Boldface:** Do not bold every proper noun or keyword. Bold only when it genuinely directs the reader's eye to a key term.
- **Inline header repetition:** Do not write bold titles that only repeat the bullet text ("**Speed:** The speed improved"). Convert to natural prose.

## Filler and communication artifacts

- **Chatbot phrasing:** "I hope this helps", "Let me know if you need anything else", "Found the issue!"
- **Sycophancy:** "Great question!", "You're absolutely right!", "Excellent catch!" Respond directly to the task.
- **Hedging stacks:** "could potentially possibly indicate" becomes "may mean".
- **Latin abbreviations:** Write "for example" instead of "e.g.", and "that is" instead of "i.e.".
- **Placeholder filler:** Remove "please note", "it is worth noting", "at this time", and "in order to" (write "to").
- **Hype words:** Remove "simply", "easy", "just", "seamlessly", "powerful". State what happens, not how effortless it feels.

## Say what it does

- State mechanics and numbers, not feelings. Replace "the cache keeps data close at hand" with "the cache stores parsed sessions in memory".
- Replace empty tautologies ("speeds up lookups by making them faster") with the mechanism ("skips database queries on repeat lookups").
- Cut vacuous sentences that could sit unchanged in an unrelated project ("The architecture is designed for reliability and scalability"). Name the concrete behavior.
- Use active voice. Name the actor: "the parser rejects the token", not "the token is rejected".
