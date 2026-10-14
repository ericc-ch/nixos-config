---
name: debug
description: "Fixes persistent or flaky bugs. Use for /debug, test/repro failures, or when the cause stays unknown after a quick look. Skip for obvious first-pass syntax or typo errors."
---

# Debug

Redact secrets before you show anything. Replace tokens, keys, and passwords with `<REDACTED>` in commands, output, and logs. Build reproduction commands against environment variables so the secret stays in the environment. If redaction removes the signal you need, say so and ask.

## Steps

1. **Build a tight feedback loop:** Create one fast command that fails reliably on this bug before touching production code. Choose the narrowest seam:
   - A focused unit or integration test.
   - A `curl` or HTTP script against a local server.
   - A CLI invocation diffing output against an expected snapshot.
   - Replaying a captured payload, event log, or fixture in isolation.
   - A throwaway script or minimal harness calling the target function directly.
   - An automated `git bisect run <script>` if finding a regression between commits.
   Run the command to confirm it goes red on the failure.
2. **Minimize:** Remove inputs, headers, flags, and steps until only the minimal failing case remains.
3. **Hypothesize:** Write 3 to 5 candidate causes before changing code. Write each as: "If X is the cause, changing Y fixes the failure." Check where grep stops (serialized shapes, DB records, microtasks, flags). Test the fastest hypothesis first.
4. **Question the premise:** If two fixes fail at the same check on the same assumption, the assumption is likely wrong. Write the assumption down in one sentence. Count failures per caller with a rerunnable script. If the same callers always fail, fix what assigns them that role. Rotate the role or move it to another caller instead of adding another workaround.
5. **Instrument:** Add targeted logging with tags like `[DBG-<n>]` or attach a debugger. Inspect runtime state to rule out wrong guesses. Find the exact failure mechanism before writing fixes.
6. **Fix the root cause:** Fix the underlying mechanism. Do not mask symptoms with workarounds.
7. **Prove it works (Red to Green):**
   - Run the reproduction command from Step 1 to prove it now passes cleanly with exit code 0.
   - *Test guardrail:* Prefer no new test over a bad test. Never add a test that asserts a mock against itself, depends on sleep/timing, or checks private implementation details instead of observable contracts.
   - If a project verification skill exists (`.agents/skills/verify-*/`), run its doctor check and drive the feature. Check side effects (files written, rows inserted, exit codes). Save the proof for review and handoff.
8. **Clean up:** Remove all debug logging and scratch files. Report the symptom, the cause, the fix, and the passing verification command.
