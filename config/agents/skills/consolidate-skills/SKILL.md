---
name: consolidate-skills
description: Consolidate overlapping skills into class-level umbrellas. Use when the skill library has grown unwieldy.
---

# Consolidate Skills

Audit the skill library for overlap and narrowness. Propose merges into class-level umbrellas — one broad skill covering a whole class of work. Apply each merge only with user approval. The goal is a library of class-level skills with rich bodies and support files — not a long flat list of one-session-one-skill entries.

## Scope

Ask the user which library to audit:

- Global: `~/.agents/skills/`
- Project-local: `./.agents/skills/`
- This repo: `config/agents/skills/`

Default to global if unstated.

## Phase 1 — Survey

List every skill and read each description. Group them into clusters by shared first word or domain keyword (e.g. `code-*`, `design-*`, `to-*`). Expect several clusters with 2+ members.

## Phase 2 — Find candidates

Flag skills that are:

- **Overlapping** — two or more skills covering the same class of task. Pairwise distinctness is the wrong bar: the right bar is "would a maintainer write this as N skills, or one skill with N labeled subsections?"
- **Narrow-named** — names containing a PR number, error string, feature codename, or a `fix-X / debug-Y / audit-Z` session artifact.

## Phase 3 — Propose merges

For each cluster with 2+ members, choose one of:

1. **Absorb into an existing umbrella** — one member is already broad enough. Patch it with labeled sections for each sibling's unique content, then remove the siblings.
2. **Create a new umbrella** — no member is broad enough. Create a new class-level skill, move unique content into labeled subsections, remove the absorbed skills.
3. **Demote to support files** — a sibling has narrow-but-valuable content. Move it into the umbrella's `references/` or `scripts/`, then remove it.

Present each proposal to the user: skill being consolidated, destination, and a one-sentence reason. Do not apply any merge without explicit approval. No skill is exempt — including index skills like `which-skill`. Handle them through the same approval flow. Do not batch-approve: one yes covers one merge.

## Phase 4 — Apply

- Move the content into the destination before removing the source, so nothing is lost.
- Remove by deleting the source directory — git is the recovery mechanism. Never delete content without first absorbing it.
- When names change, update any references: `which-skill` index lines and cross-skill mentions.

## Phase 5 — Report

End with two lists:

```
## Consolidated
- <old-name> → <umbrella> — <reason>
- ...

## Kept
- <name> — <reason not merged>
- ...
```

Every candidate appears in exactly one list. Nothing is left silently undone.
