---
name: wiki
description: "Ingests sources and files pages in ~/wiki or <repo>/wiki/. Use when the user asks to wiki, file, or add knowledge, or when research findings should persist. Skip agent-behavior notes; those go to reflect."
---

# Wiki

Persistent, compounding knowledge base, per Ryan Dahl's revision of Karpathy's llm-wiki pattern. Knowledge is compiled once and kept current; never re-derived per question.

## Two locations

- **Central:** `~/wiki` — cross-project knowledge: general research, concepts, tooling notes, things true everywhere.
- **Per-project:** `<repo>/wiki/` — knowledge about that codebase and its domain.

Route by one question: "is this true beyond this repo?" Central if yes, project if no. When unsure, project.

## Layout (both locations)

```
wiki/
├── README.md           ← the index; every page listed with a one-line summary
├── CONTEXT.md          ← project terms (per-project wiki only)
├── raw/                ← immutable sources; read only, never modified
├── concepts/           ← entity and concept pages
├── researches/         ← filed findings with citations
├── adrs/               ← ADRs (hard to reverse + surprising + real tradeoff)
└── works/<name>/       ← open unit of work only (spec.md, tickets/, map.md, session.md).
                          Delete the folder after the work is committed or done.
```

## Laws

1. **Git is the log.** No log files anywhere in the wiki. Every change lands as one commit whose message says what happened and why; `git log --oneline -- .` is the timeline.
2. **README.md is the index.** Update it in the same commit as any page add, rename, or delete. Query flow starts here.
3. **Standard links only.** `[page](../concepts/page.md)` with relative paths; never `[[wikilinks]]`. Renames fix inbound links in the same pass.
4. **raw/ is immutable.** Summarize into concepts/researches; cite `raw/...` paths as evidence.
5. **Flat until it hurts.** Promote a cluster into a subdirectory with its own README.md only when the root index gets hard to scan.

## Operations

**Ingest.** Source arrives (file, URL, transcript). Read it, discuss takeaways if interactive, write or update affected pages, update index, commit once ("ingest: <source> → touched <pages>").

**Query.** Read README.md first, drill into pages, answer with citations. A valuable answer gets filed back as a page so explorations compound.

**Lint.** Health check: contradictions between pages, claims superseded by newer sources, orphan pages, missing cross-references, concepts mentioned but lacking their own page.

**Compact.** Repair what lint finds: rewrite decayed pages, merge near-duplicates, delete dead ones, promote clusters. Version control makes aggressive maintenance safe.

**Close-out.** When a `works/<name>/` destination is shipped (code committed, or the user says the effort is done): copy lasting facts into `CONTEXT.md` (and language `AGENTS.md` if tooling), delete the whole folder including empty dirs, update `README.md` in the same change. Do not keep a closed map, done tickets, or a `session.md` stub. Do not rewrite finished planning files to match later layout. Git is the log. Do this without waiting to be asked. Ask first only if unique uncommitted planning text would be lost.

## Filing rules

Agent-written project text lives here. Skills hold how the agent behaves. Product code stays in the repo. Throwaway scripts, prototypes, and evidence dumps go in `/tmp`, never the repo. Do not write notes, glossaries, or specs at the repo root.

Research findings go to `researches/<topic>.md` with source links. Project terms go to `CONTEXT.md` in the per-project wiki. Session learnings about *the domain* belong here; learnings about *how the agent should behave* go to skills instead (`reflect`). Work artifacts (specs, tickets, maps, session notes) live under `works/<name>/` only while that unit is open, never loose. After committed or done, run Close-out.
