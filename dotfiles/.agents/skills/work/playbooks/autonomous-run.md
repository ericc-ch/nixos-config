# Autonomous run

**Define done, then drive to it without stopping.** For "going to bed", "run until done", "keep going until X", work the human reviews after stepping away.

1. State the exit condition as a checkable predicate before the first iteration: tests green, repro fixed, all N items migrated, pixel-diff zero. A vague goal stalls; a predicate lets you stop.
2. Keep a decision trail for the whole run: one row per decision with what, why, evidence, result. A TSV or markdown log under the repo's `wiki/works/<name>/`; `/tmp` for throwaway runs. A run with no trail cannot be audited or resumed.
3. Each iteration makes the smallest change the evidence justifies, verifies it against the predicate, commits if it advanced, reverts changes that did not help. "Might help" gets reverted, not left to ride.
4. Mid-run discoveries are yours: related bugs, flaky verifiers, tooling failures, orphaned follow-ups. Fix them; out-of-band fixes get their own commit or PR. Do not park reversible work for the human. Surface only irreversible actions, genuine product calls no experiment can settle, or a real dead end. Return to the predicate after each side fix.
5. Checkpoint every iteration in the trail: what changed, whether the predicate moved.
6. Stop when the predicate is met. A plateau is not a stop: pivot approach and keep pushing. Never relax the predicate to declare victory.

**Reply:** exit condition, iterations run, what landed, what was discarded, final predicate state.
