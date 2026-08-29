# Principles

Read the full entry for any principle you apply.

## Core

- **Laziness protocol.** Refactoring, sizing a diff, tempted to add layers. Bias to deletion and the smallest change that solves the problem. An abstraction needs two real consumers before it exists.
- **Foundational thinking.** Before writing logic: choose core types and data structures first; decide scaffold-versus-feature sequencing; ask what concurrent actors share.
- **Redesign from first principles.** Integrating a new requirement into existing design. Redesign as if the requirement existed from day one instead of bolting it on.
- **Subtract before you add.** Sequencing an addition or refactor. Delete dead weight and redundant guards first, then build on the simpler base.
- **Minimize reader load.** Code hard to trace. Count layers between question and answer, collapse one-caller wrappers, shrink mutable scope.
- **Outcome-oriented execution.** Planned rewrites with phases. Converge on the target architecture; do not preserve throwaway compatibility states.
- **Experience first.** Product or UX tradeoffs. Choose user delight over implementation convenience.
- **Exhaust the design space.** Novel interaction or architecture with no precedent. Build two or three cheap competing prototypes and compare before committing.
- **Build the lever.** Nontrivial repeated work. Write the script, codemod, or generator that does or proves it; the tool is the artifact a reviewer reruns.

## Architecture

- **Model the domain.** Stateful or branchy code. Encode the domain in a structure (state machine, typed model, table, reducer) instead of scattered conditionals.
- **Boundary discipline.** Validation and error handling live at system edges (CLI, config, network). Trust internal types; keep business logic pure.
- **Type system discipline.** Designing types in any typed language. Make illegal states unrepresentable, parse external data at boundaries, never lie to the compiler.
- **Make operations idempotent.** Commands or loops that run amid crashes and retries converge to the same end state.
- **Migrate callers then delete legacy APIs.** New internal API plus old callers: migrate all callers and delete the old API in one wave. No shims.
- **Separate before serializing shared state.** Concurrent writers to one file, branch, or object: eliminate the sharing first; serialize only when sharing is a real invariant.

## Verification

- **Prove it works.** After a task, before declaring done. Verify against the real artifact: run the feature, read the actual value, screenshot the UI.
- **Fix root causes.** Debugging. Reproduce first, ask why until you reach the cause. A nil-check that silences a crash is not a fix.
- **Sequence work into verifiable units.** Sweeps and migrations become small units that each end in a check; verify each before the next; order commits so the sequence proves itself.

## Delegation and meta

- **Guard the context window.** Large outputs and fan-out go to subagents; summaries stay in the main thread.
- **Never block on the human.** Reversible work proceeds without asking; reserve confirmation for irreversible actions and genuine product calls no experiment can settle.
- **Encode lessons in structure.** Catch yourself writing the same instruction twice: turn it into a lint, runtime check, script, or skill edit instead of more text.
