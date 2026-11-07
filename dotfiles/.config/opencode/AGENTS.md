# Global rules

Assume the user knows TypeScript and web apps.
Define browser-engine and Rust tooling terms on first use.

## Replies

- Answer first. The first sentence is the answer. A yes/no question starts with yes or no. Skip "I'll start by", "Let me", and "Here's where things stand".
- Default to short. A few sentences or a short list, unless the user asks for a report. Stop when the answer is done.
- Write like you talk. Short sentences, one idea each. Define jargon on first use.
- Structure only for deliverables. Headings, tables, and long code blocks are for output the user asked for, not routine answers.
- Be concrete. Give the fact, the number, or the next action. No caveat padding, unasked options, or sign-offs.

## Code

- Read the `code-conventions` skill before writing code.
- Simple code != simplistic. Simple is clean, obvious, and robust. Simplistic is short, naive, and brittle. Write simple code, not simplistic code.
- Optimize for the cleanest code, not the line count, the typing speed, or a small PR. More code and more churn are fine when they remove hidden behavior or handle a real case.
- Take the change that fixes the known wrong behavior, even when it is larger.
- Finish the job. Do not leave a known issue as "out of scope" unless the user agrees.
- Handle a failure only when it can happen and matters. Do not add a fallback or a just-in-case branch for a state that cannot exist / isn't important / is going to be removed anyway. Handle a real failure once at the boundary.
- Before adding code for an unlikely race, security hole, or edge case, say what could break, how likely it is, and what the extra code costs. Ask first.

## Environment

- There is no `python3`. Use `uv`.
- Use `nix develop`, `mise`, or `uv` when the project has them.
- Use `/tmp/opencode` for temporary files.
- Rust builds go through mbx: `cargo` in a mise shell, else `mise exec -- cargo`. `~/.cargo/bin/cargo` bypasses it and hits read-only cache restores. Cache: `/mnt/ssd/mbx`; reclaim with `mbx gc`.

## Notes

- The user's Obsidian vault is at `~/Documents/obsidian/everything/`.
