---
name: prune-comments
description: "Audits and removes code comments: classifies each as Tautology, Stale, Excuse, or Decision Record; keeps only SAFETY invariants and spec URL citations (with optional 1-line spec disagreement/deviation notes). Use for /prune-comments, comment audits, or cleaning diffs."
---

# Prune comments

Code explains *how*; types, tests, commit history, and ADRs explain *why*. Keep only comments that carry a machine or spec obligation that code cannot express.

## Allowed comments in code

Every surviving comment block in code must be one of:

1. **Safety invariant:** `// SAFETY: <why the unsafe block is sound>`.
2. **Spec or RFC citation:** `// https://...` or `/// <https://...>`, optionally paired with a single line stating a shipped-browser disagreement, deviation, or spec-delegated UA constant choice.

All other `//`, `///`, `//!`, and `/* */` prose is removed.

## Process

### 1. Categorize every comment in scope

Place each comment into one of four categories and take its action:

- **Tautology (Delete):** Repeats what types, names, or control flow already say, including `# Errors` / `# Panics` boilerplate and narrative step markers.
- **Stale (Delete):** Describes removed code, old behavior, or dead paths. If the comment claims a code path is dead, verify and delete the dead code too.
- **Excuse (Delete + fix or file issue):** Explains away a hack, partial implementation, or workaround in our own code. Fix the underlying code if small; otherwise delete the comment and file an issue (or record an upstream engine gap in `docs/upstream.md`).
- **Decision Record (Move to ADR or topic doc, then delete):** Documents a non-obvious architectural decision.
  - Create or update an ADR in `docs/adr/NNNN-slug.md` **only** when all three hold:
    1. **Hard to reverse:** changing course later has real cost.
    2. **Surprising without context:** a future reader will ask why it wasn't done the obvious way.
    3. **Result of a real trade-off:** genuine alternatives were rejected for specific reasons.
  - Use the tight ADR format:
    ```md
    # {Short title of the decision}

    {1-3 sentences: what's the context, what did we decide, and why.}
    ```
  - If the decision is a concept-owner rule, size measurement, or upstream fork note, fold it into `docs/owners.md`, `docs/size.md`, or `docs/upstream.md` instead of a new ADR.

### 2. Strip prose from spec citations

When a comment mixes prose with a valid spec URL:
- verify the URL points to the right spec section;
- delete the tautological prose and keep only the bare URL (`// https://...` or `/// <https://...>`) plus any 1-line browser-vs-spec disagreement or UA constant choice.

### 3. Verify

Run `tools/check` (or the project's compiler, test suite, and comment lint) so that:
- no broken intra-doc links, unused imports, or syntax errors remain;
- the comment lint passes on every cleaned scope.
