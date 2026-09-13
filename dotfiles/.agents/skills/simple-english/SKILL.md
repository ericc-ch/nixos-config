---
name: simple-english
description: "Writes user-facing text in short plain sentences with complete grammar. Use when the user asks to draft, polish, or rewrite docs, PRs, commits, or skill files. Skip for routine chat answers."
---

# Simple English

Write like a knowledgeable colleague talking to a teammate. Keep the tone conversational and friendly, and keep sentences short, concrete, and active. If a reader must read a sentence twice to understand it, rewrite it.

This skill summarizes the Google developer documentation style guide. When a case is not covered here, follow https://developers.google.com/style and its word list.

## Core Rules

- Use exact names instead of pronouns. Repeat "the scheduler" instead of "it". Use one name per concept. Do not cycle synonyms.
- Use active voice and present tense. Name the actor: "The server drops idle connections". Use imperative verbs for instructions: "Run the build".
- Address the reader as "you". Do not write "we", "the user", or "let's".
- Write one idea per sentence. Split a sentence that carries two clauses.
- Put the condition before the instruction. Write "To delete the file, run `rm file`". Do not write "Run `rm file` if you want to delete the file".
- Choose plain words. Use "use", not "utilize" or "leverage". Use "because", not "due to the fact that". Use "many", not "numerous".
- Avoid jargon and buzzwords. Define a term on first use when the reader may not know it.
- Cut adverbs that add no meaning. Replace "significantly improves speed" with "cuts run time from 40ms to 12ms".
- Keep terminology consistent. Use one term for one concept, with the same capitalization every time.
- Write timeless text. Avoid "currently", "soon", "new", and promises about future releases.

## Write Full Sentences

A short sentence is still a full sentence. Keep the subject, the verb, and the articles. Do not drop words to save space.

- Avoid: "Cache misses when key absent."
- Use: "The cache misses when the key is absent."
- Avoid: "One visual per node max."
- Use: "Show at most one visual per node."

Fragments belong in headings, list items, and table cells. Prose gets full sentences. Read the text aloud. If it sounds like a headline, put the missing words back.

## Say What It Does

Explain mechanics, not feelings. "The database stays close at hand" says nothing. "`.toSQL()` returns the exact string sent to the database" teaches behavior. Express clear opinions and vary sentence length.

Cut the two kinds of empty sentence:

- A tautology says the same thing twice in different words. "The cache speeds up lookups by making them faster" says nothing. State the mechanism: "The cache serves repeat lookups from memory and skips the database."
- A vacuous sentence carries no information and could sit unchanged in an unrelated project. "The system is designed for reliability and scalability" says nothing. Name the concrete behavior: "When a node fails, the system routes traffic to the remaining nodes."

State what is true and active. Do not document what was removed, what does not happen, or what used to exist. If a feature or rule is deleted, omit it silently.

## AI Tells to Remove

- Remove em dashes. Use a period or a comma instead.
- Remove mid-sentence colons used as connectors.
- Remove semicolons. Split the sentence in two.
- Remove puffery: pivotal, testament, landscape, tapestry, delve, showcase, foster, underscore.
- Remove "not just X but Y" constructions.
- Remove bold mini-titles that only repeat what the bullet says.
- Remove conversational filler: "I hope this helps", "Great question", "Let me know if".
- Remove hedging stacks. Say "may" instead of "could potentially possibly".
- Remove Latin abbreviations. Write "for example" for "e.g." and "that is" for "i.e.".
- Remove placeholder phrases: "please note", "at this time", "it is worth noting".
- Remove "please" from instructions. Write "To view the document, click View."
- Remove hype: "simple", "easy", "just", "quickly", "seamless", "powerful". Say what the user does, not how effortless it is.
- Remove exclamation marks.

## Write for a Global Audience

- Avoid idioms, slang, humor, and cultural references. Translation tools handle none of them well.
- Avoid regional and seasonal references. Do not write "summer" or "the new quarter". Use exact dates.
- Spell out an abbreviation on first use, unless the short form is better known than the long form.
- Use descriptive link text. Write "see the API reference", not "click here".
- Use inclusive language. Avoid ableist, gendered, and violent metaphors.

## Formatting

- Use sentence case for headings and titles.
- Use the serial comma: "logs, metrics, and traces".
- Put code-related text in code font.
- Keep list items parallel in structure.
