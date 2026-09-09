---
name: debug
description: "Fixes persistent or flaky bugs. Use for /debug, test/repro failures, or when the cause stays unknown after a quick look. Skip for obvious first-pass syntax or typo errors."
---

# Debug

Read `docs/CONTEXT.md` before starting if it exists.

## Steps

1. **Reproduce:** Create one command (test, curl, or CLI call) that reproduces the failure. Run the command to confirm failure before editing code.
2. **Minimize:** Remove inputs, options, and steps until only the minimal failing case remains.
3. **Hypothesize:** Write 3 to 5 candidate causes before touching code. Write each as: "If X is the cause, changing Y fixes the failure." Test the fastest hypothesis first.
4. **Question the premise:** If two fixes fail at the same gate on the same assumption, the assumption is likely wrong. Write it down in one sentence. Count failures per caller with a rerunnable script and check the skew. If the same callers always take the hit, fix what assigns them that role — rotate or move it — instead of adding another workaround.
5. **Instrument:** Add targeted logging with tags like `[DBG-<n>]` or attach a debugger. Inspect runtime state to rule out wrong guesses. Find the exact failure mechanism before writing fixes.
6. **Fix:** Fix the root cause. Do not mask symptoms with workarounds.
7. **Prove It Works:** Run the reproduction command from Step 1 to prove it passes (red to green). If a project verification skill exists (`.agents/skills/verify-*/`), run its doctor check and drive the feature. Check side effects (files written, rows inserted, exit codes). Save the proof for review and handoff.
8. **Clean Up:** Remove all debug logging and scratch files. Report the symptom, the cause, the fix, and the passing verification command.
