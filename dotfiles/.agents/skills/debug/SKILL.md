---
name: debug
description: "Fixes persistent or flaky bugs. Use when the cause stays unknown after a quick look, not for obvious first-pass bugs."
---

# Debug

Read `docs/CONTEXT.md` before starting if it exists.

## Phases

1. **Reproduce**
   - Create one command (test, curl, CLI call) that fails reliably on the bug.
   - Run the reproduction command to confirm failure before changing code.

2. **Minimize**
   - Remove inputs, configuration, and steps until the minimal failing case remains.

3. **Hypothesize**
   - Write 3 to 5 candidate causes before editing code.
   - Format each hypothesis as: "If X is the cause, changing Y fixes the failure."
   - Test the fastest hypothesis first.

4. **Instrument and Bisect**
   - Add targeted logging tagged with `[DBG-<n>]` or use a debugger.
   - Inspect runtime state to eliminate invalid hypotheses.
   - Identify the exact failure mechanism before writing fixes.

5. **Fix**
   - Address the root cause.
   - Run the reproduction command to confirm it passes.
   - Run the test suite to verify no regressions.

6. **Clean Up**
   - Remove all `[DBG-*]` tags and scratch files.
   - Report the symptom, root cause mechanism, fix, and verification command.
