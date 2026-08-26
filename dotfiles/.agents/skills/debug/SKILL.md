---
name: debug
description: "Runs a reproduce-minimize-hypothesize loop for bugs that survived a first fix or only happen sometimes. Use when the cause is still unknown after a quick look. Skip for an obvious first-pass bug; that is do-work."
---

# Debug

Mandatory phases; do not skip. Read `wiki/CONTEXT.md` if present. Root cause or nothing: a nil-check that silences a crash is not a fix.

## Phase 1: Reproduce with one command

Create a single command (test invocation, curl, CLI call) that fails reliably because of this bug and passes when fixed. Under five seconds. No code fixes until it has run red.

## Phase 2: Minimize

Shrink to the smallest scenario: strip config, data, steps one by one until every remaining element is provably required.

## Phase 3: Hypothesize

Write three to five candidate causes before editing anything, each as: "if X is the cause, changing Y makes it disappear." Order them by cheapest evidence first.

## Phase 4: Instrument and bisect

- Debugger or targeted logs, tagged `[DBG-<n>]` for easy removal.
- One variable at a time; runtime evidence eliminates hypotheses. When state is unclear mid-run, log and read it rather than guessing.
- Surviving hypothesis must be confirmed as the mechanism before fixing.

## Phase 5: Fix and lock

1. Regression test for the bug (see `tdd`).
2. Confirm red on current code.
3. Fix at the root cause.
4. Confirm green.
5. Full suite for collateral breaks.

## Phase 6: Clean up

Remove all `[DBG-*]` tags and scratch files. State the root cause plainly in the commit message and your reply: symptom, mechanism, fix, proof.
