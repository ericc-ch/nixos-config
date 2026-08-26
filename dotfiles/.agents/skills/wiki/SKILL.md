---
name: wiki
description: Maintain the knowledge wiki system (central ~/wiki and per-repo wiki/). Use for ingesting sources, filing research, writing pages, linting for stale claims, or when the user says "wiki this", "add to the wiki", "file that".
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
├── README.md        ← the index; every page listed with a one-line summary
├── raw/             ← immutable sources; read only, never modified
├── pages/           ← entity and concept pages
├── decisions/       ← ADRs (hard to reverse + surprising + real tradeoff)
├── research/        ← filed findings with citations
└── work/<name>/     ← one folder per unit of work:
                      spec.md, tickets/, map.md, trail logs
```

## Laws

1. **Git is the log.** No log files anywhere in the wiki. Every change lands as one commit whose message says what happened and why; `git log --oneline -- .` is the timeline.
2. **README.md is the index.** Update it in the same commit as any page add, rename, or delete. Query flow starts here.
3. **Standard links only.** `[page](../pages/page.md)` with relative paths; never `[[wikilinks]]`. Renames fix inbound links in the same pass.
4. **raw/ is immutable.** Summarize into pages; cite `raw/...` paths as evidence.
5. **Flat until it hurts.** Promote a cluster into a subdirectory with its own README.md only when the root index gets hard to scan.

## Operations

**Ingest.** Source arrives (file, URL, transcript). Read it, discuss takeaways if interactive, write or update affected pages, update index, commit once ("ingest: <source> → touched <pages>").

**Query.** Read README.md first, drill into pages, answer with citations. A valuable answer gets filed back as a page so explorations compound.

**Lint.** Health check: contradictions between pages, claims superseded by newer sources, orphan pages, missing cross-references, concepts mentioned but lacking their own page.

**Compact.** Repair what lint finds: rewrite decayed pages, merge near-duplicates, delete dead ones, promote clusters. Version control makes aggressive maintenance safe.

## Filing rules

Research findings go to `research/<topic>.md` with source links. Session learnings about *the domain* belong here; learnings about *how the agent should behave* go to skills instead (`learn`). Work artifacts (specs, tickets, maps) live under `work/<name>/`, never loose.
