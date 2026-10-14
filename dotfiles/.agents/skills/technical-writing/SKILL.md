---
name: technical-writing
description: "Applies clear documentation standards: Diátaxis structure, active voice, condition before action, and rhythm variation. Use when writing or editing docs, guides, RFCs, readmes, PR bodies, or commit messages."
---

# Technical writing

Write so an engineer understands on the first read.

## Core rules

- Cut every word that does no work. If the sentence survives without a word, remove it. "In order to" becomes "to". "It is important to note that" is nothing.
- Use the short, everyday word. "Use", not "utilize". "Help", not "facilitate". "Run", not "execute". A long word must buy its length with precision.
- Name real things. Use the real symbol, file, flag, or command name instead of describing it.
- If a rule makes a sentence worse, fix the sentence another way or leave it alone. A sentence that obeys every rule but reads like a machine wrote it has failed.

## Vary the rhythm

Do not make every sentence the same length or tone.

- Mix sentence lengths on purpose. Short sentences land a point. Longer ones carry a fact with its condition or consequence.
- Split a sentence that carries two thoughts. Keep a longer sentence that carries one complete idea.
- Have a view where the format allows it. Explanation weighs trade-offs; state what you make of them instead of listing pros and cons. Reference stays dry.
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

## Structure and formatting

- Use sentence case for headings. A task heading is a verb phrase ("Create a profile"). A concept heading is a noun phrase ("Authentication tokens").
- Use numbered lists for sequences. Use bulleted lists for unordered items.
- Keep list items parallel in grammatical structure.
- Put code symbols, file paths, and commands in code font.
- Put UI labels in bold.

Pair this skill with `unslop` to remove AI patterns, filler, and banned metaphors.
