---
name: explain-code
description: Walk the user through unfamiliar code one file at a time, code-forward, with signatures, example usage, and call-stack traces. Maps Rust to TypeScript/Effect for a senior TS engineer new to Rust. Use when the user asks to explain, diff, or walk through code, or says "continue" on a walkthrough.
metadata:
  opencode/autoinvoke: false
---

# Explain Code

Format for explaining code to a senior TypeScript engineer who is new to Rust (Effect/ZIO background). Each rule below was earned by an explicit correction: "rewrite it, focus on the code", "go slower, one by one", "easily digestible". Treat them as senior. Never lecture on programming basics.

## Format rules

1. **One file at a time.** Never front-load several files. End each pass with a next-file proposal (2-3 options) and let them choose.
2. **Lead with interfaces and signatures.** Compact signature blocks grouped by lifecycle (construction → dial → response). Full type surface before behavior.
3. **Example usage + call stack.** Canonical usage snippet, then an annotated call-stack trace with file:line references showing what happens under the hood.
4. **Code-forward.** Quote the actual code with line numbers; annotate, don't paraphrase.
5. **TS/Effect mapping only where it genuinely helps.** Rust idioms get a one-line model (enum = discriminated union, Result = the E channel of Effect, Box = owning pointer). No mapping for things they already know.
6. **Easily digestible.** Short sections, tables for comparisons, no walls of prose.
7. **Answer "why" directly.** "Why values and not throws?" gets the model comparison (Result = E channel, panic = die/defect), not philosophy.
8. **Respect the code's own seam.** Explain the architecture the code documents (e.g. the hard seam, conversion points) as the organizing idea.
9. **When asked to diff:** start with `git diff main --stat` + commit list, summarize new files in a table, then walk the key files one by one.

## Walkthrough protocol

1. Read the file fully first (read tool, not memory).
2. One sentence: the file's one job.
3. Type surface: signatures grouped by lifecycle.
4. Example usage.
5. Call-stack trace with file:line.
6. Next-file proposal.

## Audience profile

- Senior SWE, TypeScript. Knows effect-ts/ZIO: Result/Error/Requirement channel, typed errors, exhaustiveness.
- New to Rust: needs idioms mapped (ownership, moves, enums, traits, lifetimes, `?`, Box), NOT programming basics.
- Wants: signatures, interfaces, call stacks, concrete code. Dislikes: hand-holding, explaining what comments and modules are, tutorials.

## Current state

tinybrowser `crates/net/` walkthrough in progress — covered files and the established Rust↔TS mapping table live in `references/progress.md`. When continuing, read that file first and resume at the next-file proposal.

## Close out

Before stopping, update `references/progress.md` with files covered and the next proposal.
