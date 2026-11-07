---
name: explain
description: "Explains code and concepts. Use when the user asks to explain, walk through, or says continue."
---

# Explain

Start from what the reader knows and build to the answer. Use the `technical-writing` and `unslop` skills. Follow their rules.

## 1. Find out before you explain

Answer three questions: what it is, how it works, and why it is shaped that way.

- **What:** name the thing in plain words, then tie it to the case in front of you.
- **How:** follow the real path. Name the entry point, the data that moves, and where each part lives. Give the gotchas.
- **Why:** read `git log`, `git blame`, PR bodies, issues, and ADRs. Separate what you found from what you infer. Never invent a reason. If the record is silent, say so.

Start with the smallest complete answer, then add layers when they ask.

## 2. Visualization

- Use existing visualization tool or guide if present, else use Mermaid.
- Use an HTML artifact only when Mermaid and text are too dense.
- For three or more moving parts, draw a short series. Each diagram adds one part. A single diagram with everything at once is reference, not teaching.

## 3. Code

- Show the simplified snippet that proves the idea.
- Quote real code with `path:line`. Never explain from memory. This is also how you answer the why question: the record, not a guess.
- Use a before and after pair when showing a change. No diff sketches.
