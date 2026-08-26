# Bug fix

**Every shipped line traces to runtime evidence.** A change that "might help" is a hypothesis, not a fix; it does not ship. When evidence refutes a hypothesis, revert what it motivated.

1. Reproduce it yourself on the real surface. Run the app, hit the endpoint, load the page. Do not hand the repro back to the user. Cannot reproduce directly? Force it: synthesize the trigger, tighten conditions, instrument until it fires. Ask the user only with a stated reason the surface cannot reach the target.
2. Binary-search the cause. Form three to five candidate hypotheses as "if X is the cause, changing Y makes it disappear". Rule them out one at a time with runtime evidence, taking the split that cuts the most problem space first. Instrument and read logs while the code runs; do not guess. Confirm the surviving mechanism before planning the fix. Route through `debug` for the full disciplined loop on hard or intermittent cases.
3. Plan the fix. If it crosses a function boundary, sketch types and module shape first.
4. Verify on the same surface: the original repro now passes. Inconclusive or wrong-surface is not a pass; flag it. Unit tests show branch behavior, not bug absence.
5. Stage history so the failing repro lands before the fix: failing test first, then fix (see `tdd` when a cheap local test path exists). The diff tells the story.
6. Run `playbooks/opening-a-pr.md`.

**Reply:** what was broken, root cause, fix, how you verified. Paste failing-then-passing output verbatim.
