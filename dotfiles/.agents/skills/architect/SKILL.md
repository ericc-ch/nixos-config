---
name: architect
description: "Sketches types, signatures, and module shape before code, then fills in the implementation against the sketch. Use for /architect, 'architect this', 'design this', or non-trivial work where jumping to code would lock in the wrong shape."
---

# Architect

Sketch the shape before writing the code. The sketch is the contract. It is cheaper to throw away than an implementation.

## Start

Open a todo list with one entry per phase:

1. Ground
2. Sketch
3. Agree (opt-in)
4. Implement
5. Scrap

## Phase A: Ground the problem

Build a real model of every system the new code touches. Read the files, the callers, and the tests. Use the `explain` skill for how it works. If the surrounding shape is the problem, use `improve-codebase` first.

Produce:

- The entry points and the data that crosses the boundary.
- The constraints: existing types to interoperate with, callers that cannot break, invariants that must survive.
- The dependencies and which category they fall into: in-process, local substitute, remote but owned, or true external.

Skip this phase only when the work is genuinely greenfield with no surrounding system.

## Phase B: Sketch two shapes

Read `../../references/codebase-design.md` first. Use its terms: module, interface, depth, seam, adapter, leverage, locality.

Design it twice. Write at least two structurally distinct candidates, not two variations of one shape. For each:

- The caller's view first. Show the smallest realistic usage example.
- The types, signatures, and module boundaries.
- What the interface hides and what it exposes.
- Where the seam goes and what sits behind it.
- The trade-offs, in terms of leverage and locality.

Sketch them yourself, one after the other. Keep them separate until both exist.

Screen each candidate against `references/design-red-flags.md` before choosing. Prefer the shape that hides more complexity behind a smaller interface, and the one where an agent that sees only one file makes the right change.

Write the rationale with `references/rationale-template.md`. The caller's usage comes first. The type sketch is derived from it.

If the design has order-dependent state, run the `statechart` skill on the model before implementation. A counterexample is cheaper now than after the code exists.

## Phase C: Agree (opt-in)

Proceed to implementation by default. Pause for sign-off when the user asks, or when the design is a one-way door: a public API, a data migration, or a change that is expensive to undo. Present the sketch and the rationale, then wait.

## Phase D: Implement against the sketch

Replace `not implemented` bodies with code. The sketch is the contract. When implementation needs a parameter or a step the sketch did not have, stop and decide:

- The sketch was wrong, so revise it.
- The requirement was missed, so add it to the sketch.
- The implementation is overreaching, so pull it back.

Do not silently absorb the difference.

## Phase E: Scrap a wrong shape

A single workaround is not a signal. A pattern is. Scrap the sketch when:

- The same shape of workaround appears in unrelated places.
- Unrelated edge cases all need their own branch.
- Types need `any`, casts, or always-set optional fields to compile.
- Callers must know the module's internal rules to use it.
- You reach for a lock when the sketch said state was not shared.

When you scrap:

1. Re-read what was built.
2. Redesign as if the new constraints were there from the start.
3. Make the new sketch smaller than the old one before it grows.
4. Return to Phase B.

## Output

One file with the new types and signatures for a small change. A module map plus type definitions for a larger one. The rationale ships beside it.

**Reply:** the chosen shape, the caller's view, the alternatives and why they lost, what the interface hides, the first implementation step, and any open questions.
