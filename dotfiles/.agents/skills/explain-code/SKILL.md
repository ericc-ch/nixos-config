---
name: explain-code
description: Walk the user through unfamiliar code one file at a time, code-forward, with signatures, example usage, and call-stack traces. Use when the user asks to explain, diff, or walk through code, or says "continue" on a walkthrough.
---

# Explain Code

Walk unfamiliar code for a senior engineer. Treat them as senior. Never lecture on programming basics.

## Format rules

1. **One file at a time.** Never front-load several files. End each pass with a next-file proposal (2-3 options) and let them choose.
2. **Lead with interfaces and signatures.** Compact signature blocks grouped by lifecycle of the type (construct → use → teardown, or whatever order the API actually has). Full type surface before behavior.
3. **Example usage + call stack.** Canonical usage snippet, then an annotated call-stack trace with `file:line` showing what happens under the hood.
4. **Code-forward.** Quote the actual code with line numbers; annotate, don't paraphrase.
5. **Map idioms only across a language gap.** If the reader's home language differs from the code, give a one-line model for the unfamiliar idiom. No mapping for things they already know.
6. **Easily digestible.** Short sections, tables for comparisons, no walls of prose.
7. **Answer "why" directly.** Model comparison, not philosophy (e.g. `Result` vs throw → typed error channel vs defect/panic).
8. **Respect the code's own seam.** Explain the architecture the code documents (hard seams, conversion points, module boundaries) as the organizing idea.
9. **When asked to diff:** start with `git diff <base> --stat` (default base `main`) + commit list, summarize new files in a table, then walk the key files one by one.

## Walkthrough protocol

1. Read the file fully first (read tool, not memory).
2. One sentence: the file's one job.
3. Type surface: signatures grouped by lifecycle.
4. Example usage.
5. Call-stack trace with `file:line`.
6. Next-file proposal.

If they say "continue", take the last proposed file (or the one they pick).

## Shape

```
**Job.** <one sentence>

**Signatures.** <lifecycle-grouped>

**Usage.** <canonical snippet>

**Call stack.**
<file:line> → <file:line> → …

**Next.** 1. …  2. …  3. …
```
