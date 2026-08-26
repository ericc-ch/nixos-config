---
name: tdd
description: Test-driven development with a red-green-refactor loop. Use when the user explicitly asks for TDD, a failing test, or a regression test, OR when a bug has an obvious cheap local test target. Skip when the test path is unclear, expensive, or integration-heavy.
---

# Test-Driven Development

Test at the highest practical level: prove the app works through real entry points, not micro-units. Read `CONTEXT.md` if present before writing tests.

## Trigger discipline

Write tests when asked, or when a bug has an obvious cheap test target (pure function, endpoint, parser). Skip and say why when the path is integration-heavy, slow to arrange, or better proven on the live surface.

## The loop

1. **Red.** Write one test at the public boundary for the contract you want. Run it; confirm it fails.
2. **Green.** Minimum code to pass.
3. **Refactor.** Clean up; tests stay green.
4. Repeat per contract. Never write production code with no failing test demanding it.

## Priorities, high to low

1. End-to-end workflows through public entry points (CLI commands, HTTP endpoints).
2. Integration across subsystem boundaries.
3. Unit tests sparingly: complex domain math, parsers, branching algorithms only.

## What to test

- Contracts and invariants: inputs, observable outputs, persisted state, error codes.
- Public interfaces only. An internal refactor breaking a test without behavior change means the test dies.
- Hardcoded expected outputs; never mirror production logic in assertions.

## Delete on sight

- Trivial glue tests ("1+1=2"), existence/registration checks, anything the type checker already guarantees.
- Deep third-party mocks that mimic vendor shapes; they lie when vendors change.
- Shallow UI checks (CSS classes, mount booleans). Test user-visible workflows instead.
- Deleted-name tests and arbitrary fake-input negatives without a general rule behind them.
