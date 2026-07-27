---
name: ask-matt
description: Find the right skill for your task. A simple index of all skills in this repo.
disable-model-invocation: true
---

# Ask Matt

Use this guide to pick the right skill for your work. Most work follows one main path. Other tasks start from bugs, cleanup, or research.

## Main path: idea to shipped code

Follow this path when you want to build a feature or new idea.

1. **Clarify the idea**
   - Run `/grill-with-docs` to answer questions about your idea.
   - The agent saves notes to `CONTEXT.md` and design decisions to ADR files.
   - (If you do not have a codebase yet, use `/grill-me` instead.)

2. **Test risky design questions (Optional)**
   - If a question needs runnable proof (like testing a UI or state logic), pause and test it:
     - Run `/handoff` to save your notes.
     - Open a new chat session and run `/prototype` to build quick throwaway code.
     - Run `/handoff` in the prototype chat to bring your findings back to the main chat.

3. **Choose your build size**
   - **Large project (multiple sessions):**
     - Run `/to-spec` to write a full specification.
     - Run `/to-tickets` to split the specification into small tasks on your issue tracker.
     - Run `/implement` in a fresh chat window for each task, working on unblocked tasks first.
   - **Small task (single session):**
     - Run `/implement` in the current chat window.

4. **Build and review**
   - `/implement` automatically uses `/tdd` to write tests before code.
   - `/implement` runs `/code-review` to check quality before committing.

### Managing chat context
- Keep steps 1 through 3 in the same chat window so the agent remembers the context.
- If the chat window gets too full or slow, run `/handoff` and start a new chat window.
- Each `/implement` task for a multi-session project should start in a clean chat window.

---

## Starting points for other tasks

- **Raw bugs or user requests:** Run `/triage` to clean up incoming raw requests into clear tasks. Do not run triage on tasks created by `/to-tickets`.
- **Hard or confusing bugs:** Run `/diagnosing-bugs`. Create one command or test that reproduces the bug, then fix the code.
- **Huge or unclear projects:** Run `/wayfinder` to split big unknowns into decision questions on your issue tracker. Resolve the questions one by one, then run `/to-spec` to start building.

---

## Codebase health

- **Code cleanup:** Run `/improve-codebase-architecture` to find areas in the code that need refactoring or better structure.

---

## Terms and design rules

- **`/domain-modeling`**: Clarify project terminology and write ADR decision notes.
- **`/codebase-design`**: Rules for writing simple, clean modules.

---

## Session management

- **`/handoff`**: Save your current chat to a Markdown file so you can open a fresh chat window without losing context.
- **`/compact`**: Summarize old messages while staying in the same chat window.

---

## Standalone tools

- **`/grill-me`**: Clarify an idea when you do not have a codebase.
- **`/prototype`**: Write quick throwaway code to test a design or UI question.
- **`/research`**: Have an agent read docs and write a report while you keep working.
- **`/teach`**: Learn a technical concept step by step.
- **`/writing-great-skills`**: Guide for writing and editing skills.

---

## First-time setup

- **`/setup-matt-pocock-skills`**: Run this once before starting your first workflow to set up your issue tracker and label settings.
