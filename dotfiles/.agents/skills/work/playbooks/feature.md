# Feature

**Plan, implement, review, verify.**

1. Ground yourself in the affected subsystem: read the entry points and trace the flow before changing anything (the `how` move).
2. Sketch the design before code: types, signatures, module layout. State it in one paragraph or a small diagram. Skipping stays explicit as `architect skipped: <reason>`; never fold the design decision silently into implementation.
3. Write the throughput checkpoint as four items; a dimension that genuinely does not apply keeps its item with `n/a: <reason>`.
   - Blocking first steps: gates that run before any parallel work.
   - Independent workstreams: disjoint files or layers that parallelize.
   - Shared mutable state: default to splitting the target (separate-before-serializing-shared-state). Serialize only for real invariants.
   - Smallest safe decomposition: if one worker is best, name why.
4. Choose the data shape first per model-the-domain: a state machine over scattered booleans, a table over branching, a typed model over repeated assumptions. Then implement. Delegate mechanical sweeps to a subagent with specific scope; write gnarly core logic yourself. Commit liberally.
5. Verify on the matching surface. Run the feature end to end; screenshot UI work. Inconclusive is a fail.
6. Rebase into small ordered commits; each commit is landable and tells the story (sequence-verifiable-units).
7. Design contested? Run the adversarial pass from `review` against your own diff before shipping.
8. Run `playbooks/opening-a-pr.md`. If this was the last open slice, run wiki Close-out on `wiki/works/<name>/`.

**Reply:** what you built, what you chose and why, open decisions. Tables for design alternatives.
