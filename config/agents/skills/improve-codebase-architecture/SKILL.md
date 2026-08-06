---
name: improve-codebase-architecture
description: Scan a codebase for architectural cleanup candidates, present them in an HTML report, then grill through the one you pick.
---

# Improve Codebase Architecture

Scan your codebase to identify architecture cleanup candidates and refactoring opportunities.

## Process

### 1. Explore recent active code

Inspect recent git commits (`git log --oneline`) to find frequently changed areas in the codebase.

Look for:

- Modules split into too many small files.
- Code logic that is difficult to test.
- Tightly coupled components leaking internal details.
- Untested public APIs.

### 2. Generate an HTML report

Write a standalone HTML report file to `/tmp/architecture-review-<timestamp>.html` (or equivalent OS temp directory) and open it for the user (`xdg-open` on Linux, `open` on macOS).

Include cards for each refactoring candidate showing:

- **Files involved:** List of target modules.
- **Problem:** Clear description of current code friction.
- **Solution:** Plain English proposal for refactoring.
- **Before / After diagram:** Visual diagram illustrating structural changes.
- **Recommendation level:** `Strong`, `Worth exploring`, or `Speculative`.

End the report with a **Top recommendation**: which candidate you would tackle first and why.

### 3. Grilling loop

Ask the user which candidate they want to tackle first. Then run `/grilling` to walk through the refactoring with them. Cover constraints, dependencies, the shape of the improved module, what sits behind its interface, and which tests survive.

Update docs as decisions crystallize:

- **New module name?** Add the term to `CONTEXT.md` (create it if missing).
- **Fuzzy term sharpened during the conversation?** Update `CONTEXT.md` right there.
- **User rejects a candidate with a real reason?** Offer to record it as an ADR so future reviews do not re-suggest it. Only offer when the reason would actually stop a future explorer — skip ephemeral reasons like "not worth it right now".
- **User wants to explore alternative interfaces?** Run `/codebase-design` for the deep-module principles.
