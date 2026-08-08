---
name: diagnosing-bugs
description: Systematic process for diagnosing and fixing hard bugs and performance regressions.
---

# Diagnosing Bugs

Follow these mandatory phases to debug hard or intermittent issues. Do not skip phases.

Read `CONTEXT.md` (if present) before debugging to understand the relevant modules and architecture rules.

---

## Phase 1 — Create a reproducible command

Create **one single command** (a test invocation, curl script, or CLI command) that consistently fails because of this bug.

- **Must fail reliably:** The command MUST fail on the current code and pass when fixed.
- **Must be fast:** Aim for execution time under 5 seconds.
- **Do not guess code fixes** until you have run this failing command.

If you cannot create an automated command, ask the user for sample logs, test environments, or reproduction steps.

---

## Phase 2 — Minimize the reproduction

Shrink the failing test case to the smallest possible scenario.
- Remove unnecessary config, data, and steps one by one.
- Verify that every remaining element is required to reproduce the bug.

---

## Phase 3 — List hypotheses

Write down 3 to 5 potential causes before editing any code.
- Format each hypothesis as: *"If X is the cause, then changing Y will make the bug disappear."*
- Share the hypothesis list with the user if available.

---

## Phase 4 — Instrument and inspect

Test your hypotheses:
- Use a debugger or targeted log statements.
- Tag every temporary debug log with a unique prefix (e.g., `[DEBUG-123]`) so they can be removed easily.
- Change only one variable at a time.

---

## Phase 5 — Fix and add a regression test

1. Write a regression test for the bug.
2. Verify that the test fails on current code.
3. Apply your fix.
4. Verify that the test passes.
5. Re-run your full test suite to prevent collateral breaks.

---

## Phase 6 — Cleanup

- Remove all `[DEBUG-123]` temporary logs.
- Remove any temporary scratch files.
- Summarize the root cause clearly in your git commit message.
