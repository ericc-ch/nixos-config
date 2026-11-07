---
name: technical-writing
description: "Applies clear documentation standards: Diátaxis structure, active voice, condition before action, and rhythm variation. Use when writing or editing docs, guides, RFCs, readmes, PR bodies, or commit messages."
---

# Technical writing

Write so an engineer understands on the first read.

## Core rules

- Cut every word that does no work. If the sentence survives without a word, remove it. "In order to" becomes "to". "It is important to note that" is nothing.
- Use the short, everyday word. "Use", not "utilize". "Help", not "facilitate". "Run", not "execute". A long word must buy its length with precision.
- Name real things. Use the real symbol, file, flag, or command name instead of describing it. The codebase is the word list.
- Do not invent jargon. Use the words a developer would say out loud.
- If a rule makes a sentence worse, fix the sentence another way or leave it alone. A sentence that obeys every rule but reads like a machine wrote it has failed.

## Vary the rhythm

Do not make every sentence the same length or tone.

- Mix sentence lengths on purpose. Short sentences land a point. Longer ones carry a fact with its condition or consequence.
- Split a sentence that carries two thoughts. Keep a longer sentence that carries one complete idea.
- Have a view where the format allows it. Explanation weighs trade-offs. State what you make of them instead of listing pros and cons. Reference stays dry.
- Be specific over sterile. Write "a column rename fails the build", not "schema changes can cause issues".

## Pick the mode first (Diátaxis)

One document, one mode. Match the mode to the reader's goal:

- **Tutorial (learning by doing):** Guide the beginner through concrete steps to build something. Every step produces a visible result. State what the reader should see at each point. Keep explanation to a minimum and link out to deep dives.
- **How-to (steps to a goal):** Solve a specific problem for an experienced reader. Action only, no background lecture. State assumptions, list the steps in order, and allow forks: "If you need X, do Y." Name the guide by the task: "How to export metrics", not "Metrics exporter".
- **Reference (facts for lookup):** Only describe. No instruction, no opinion. State facts, options, limits, and errors cleanly and completely. Mirror the structure of the code or system described.
- **Explanation (understanding and context):** Step back and explain architecture, design decisions, history, constraints, and trade-offs. Anchor on a real "why" question.

Do not mix modes: no reference tables inside a tutorial, and no tutorial hand-holding inside reference. Split and link instead.

## Sentence construction

- Talk to the reader as "you", in the present tense.
- Say who does what: "the compiler checks types", not "types are checked".
- Write instructions as direct commands: "Click Submit." Never "should be done".
- Put the condition before the instruction: "To delete the file, run `rm file`."
- Put the common case first, followed by exceptions.
- Sound like a knowledgeable colleague. Avoid buzzwords, figurative speech, and "please" in instructions. Never say "simply", "easy", or "quickly". If it were simple, the reader would not need docs.
- Put link text on words that name the destination. Write "see the API reference", not "click here".

## Make statements load one at a time

- One instruction per sentence. One thought per sentence elsewhere.
- Split an instruction longer than about 20 words. Split other sentences longer than about 25.
- Put a warning or condition before the step it guards.
- Keep "the" and "a". "Remove backup file" reads two ways. "Remove the backup file" reads one.
- Pick one word per action and keep it. Do not write "start" here and "initiate" there.
- Avoid "-ing" forms where a plain verb works.

## Leave no sentence open to two readings

- Keep "only" and "not" next to the word they change. "Only fails on growth" and "fails only on growth" say different things.
- Break up long noun strings. "The proto import budget check script" becomes "the script that checks the proto-import budget".
- Make every "it", "they", and "this" point at one obvious thing. Repeat the noun when in doubt.
- Keep the small words that show structure, such as "that" in "Ensure that the switch is off".
- Repeat the article in a series: "the client and the host", not "the client and host".
- Say which parts "and" or "or" joins when a sentence can group two ways.
- Use periods, not semicolons. Replace an em dash with a new sentence.
- No slashes. Write "a, b, or both" instead of "a/b" or "and/or".
- Call each thing by one name everywhere.

## Structure and formatting

- Use sentence case for headings. A task heading is a verb phrase ("Create a profile"). A concept heading is a noun phrase ("Authentication tokens").
- A heading carries the point, not just the topic ("Pick the mode first", not "Modes").
- One h1 per page. Do not skip heading levels.
- Use numbered lists for sequences. Use bulleted lists for unordered items.
- Keep list items parallel in grammatical structure.
- Put code symbols, file paths, and commands in code font.
- Put UI labels in bold.

Pair this skill with `unslop` to remove AI patterns, filler, and banned metaphors.
