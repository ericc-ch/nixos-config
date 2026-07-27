---
name: improve-codebase-architecture
description: Scan a codebase for architectural cleanup candidates and present proposals in an HTML report.
disable-model-invocation: true
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

### 3. Review candidate with user
Ask the user which candidate they want to tackle first. Run `/grilling` to refine the chosen refactoring proposal.
