# Refactoring

**You own the contract. The structure changes; the behavior does not.** For "refactor", "rename", "extract", "dedupe", "move this module", "tidy this area". Behavior changes go to feature. A refactor that smuggles in behavior loses its safety net.

1. Pin the behavior contract first: a characterization test, snapshot, or equivalence harness that captures current behavior before structure moves. Type check and lint are not a pin.
2. Name the shape the code is missing per model-the-domain: state machine, table, typed model. Boring code stays when the shape is already clear. The reshape must delete branches or invalid states, not add indirection.
3. State the target: what the module layout and call graph would be if built today. Subtract before you add: dead weight, one-caller wrappers, redundant validators first.
4. Move in small steps, each keeping the pin green. Migrate every caller and delete the old API in the same wave; no compatibility shims. Spot-check renames against actual files; they silently miss strings and prose. Delegate mechanical sweeps to subagents with specific scope; review diffs yourself.
5. Prove behavior unchanged on the real artifact: equivalence script diffing old versus new outputs, or a smoke run on the matching surface. Own the verification; never trust a delegate's "looks good".
6. Confirm it earns its place: fewer layers between question and answer somewhere, or revert.
7. Rebase into ordered commits: subtraction commit, then reshape, then cleanup, so one revert undoes one slice. Run `playbooks/opening-a-pr.md`.

**Reply:** structure that changed, the pin you held it against, the equivalence proof, reader-load delta, what got reverted.
