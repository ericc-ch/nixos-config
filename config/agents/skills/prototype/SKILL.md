---
name: prototype
description: Load this skill when the user wants a throwaway prototype to explore a design, data model, state machine, or UI options before committing.
---

# Prototype

**Throwaway code that answers a question.** The question decides the shape.

## Pick a branch

- **"Does this logic / state model feel right?"** → logic branch below. Tiny interactive terminal app; push the state machine through cases that are hard on paper.
- **"What should this look like?"** → UI branch below. Several radically different variations on one route, switchable via `?variant=` and a floating bottom bar.

Getting the branch wrong wastes the prototype. If ambiguous and the user isn't around, default to what fits the surrounding code (backend module → logic; page/component → UI) and state the assumption at the top.

## Rules (both branches)

- **Throwaway and clearly marked.** Put it next to where it will be used; name it so it's obvious. For UI, follow existing routing — don't invent new top-level structure.
- **One command to run** — project's task runner (`pnpm <name>`, `python <path>`, etc.).
- **No persistence by default.** In-memory state unless persistence is what you're checking; then scratch DB/file with a clear "PROTOTYPE — wipe me" name.
- **Skip the polish.** No tests, no abstractions, error handling only enough to run.
- **Surface the state.** After every action (logic) or variant switch (UI), show full relevant state.
- **Delete or absorb when done.** Don't leave it rotting.

## Logic branch

Right shape when the question is state transitions, data shape, or API feel — user wants to press buttons and watch state change. Wrong branch if the question is visual.

**Before coding** — one paragraph stating the state model and question (README or top-of-file comment).

**Isolate the logic** in a portable pure module the TUI wraps — reducer, state machine, pure functions, or small class; no I/O or terminal code inside. Pick the shape that fits the question, not what's easiest to wire. The shell is throwaway; this module may lift into real code later.

**TUI** — lightweight, full-screen refresh each tick (not growing scrollback). Each frame: (1) current state, pretty-printed, one field per line; bold names, dim context; (2) keyboard shortcuts at bottom. Read one keystroke/line → mutate → re-render. Fit on one screen.

**Runnable** — one script in the project's task runner; command in README if no runner.

**Anti-patterns** — no tests, no real DB (unless that's the question), no generalising beyond one question, don't mix TUI into the logic module, don't ship the shell to production.

## UI branch

Right shape when the question is layout, hierarchy, or how a page should feel. Wrong branch if it's logic/state.

**Prefer sub-shape A** — variants on an **existing route**, same data fetching/auth; only rendering swaps via `?variant=`. New UI that would live inside an existing page counts as A. **Sub-shape B** (new throwaway route) only when there's genuinely no host page — name it obviously (`prototype` in path). Before B, check embedding isn't possible.

**Variants** — default 3, cap at 5. Structurally different: layout, hierarchy, primary affordance — not colour tweaks. Each exports e.g. `VariantA`, `VariantB`. Shared header OK; shared layout defeats the point.

**Wire** — switch on `searchParams.get('variant') ?? 'A'`; pass shared data into each variant. Floating bottom bar: prev/next arrows (wrap), current label, updates URL (shareable/reload-stable). `←`/`→` keyboard unless focus in input/textarea/contenteditable. Visually distinct from the page. Hide in production (`NODE_ENV` or equivalent). One shared switcher component.

**When a variant wins** — record which and why; delete losers and switcher. A: fold winner into existing page. B: promote to real route, delete throwaway.

**Anti-patterns** — colour-only variants, shared layout across variants, real mutations (read-only/stubs OK), promoting prototype code directly to production without rewrite.

## When done

The answer is the only thing worth keeping. Capture it (commit, ADR, issue, `NOTES.md` next to the prototype) with the question it answered. If the user isn't around, leave a placeholder for the verdict before deleting.
