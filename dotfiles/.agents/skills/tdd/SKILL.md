---
name: tdd
description: Write, prune, or review tests using contract-first test-driven development.
---

# Test-Driven Development

Test at the highest practical level. Prefer end-to-end tests that prove the app works over micro-unit tests.

Read `CONTEXT.md` (if present) before writing tests.

## The Loop

1. **Red:** Write a test at the public boundary for the contract you want. Run it and confirm it fails.
2. **Green:** Write the minimum code needed to make the test pass.
3. **Refactor:** Clean up the code. Keep tests green.

---

## Testing Priorities (High to Low)

1. **End-to-end workflows:** Test the whole app through real public entry points (CLI commands, HTTP endpoints, workflow runs).
2. **Integration across boundaries:** Test interactions between subsystems and adapters.
3. **Unit tests (sparingly):** Reserve unit tests only for complex domain math, parsers, or branching algorithms where hitting every edge case in E2E is too slow.

---

## What to Test

- **Contracts and invariants:** Test inputs and observable outputs (returned values, persisted state, emitted events, error codes).
- **Public boundaries:** Test through public interfaces. If an internal refactor breaks a test without changing external behavior, delete or rewrite the test.
- **Independent expectations:** Hardcode expected outputs. Do not mirror production logic in test assertions.

---

## Tests to Avoid and Delete

Delete or skip tests in these categories:

- **Trivial unit tests:** Do not write unit tests for glue code, simple math, or shallow functions ("1 + 1 = 2"). If a higher-level test already exercises the code, skip the unit test.
- **Existence and registration:** Do not test that a route, command, component, or class merely exists or registered. Test what happens when a caller runs it.
- **Type checker territory:** Do not test type shapes, field presence, or simple getters that the compiler already guarantees. Save schema assertions for untrusted external I/O boundaries.
- **Third-party mock mimicry:** Do not build deep mocks that assume the shape of external APIs. When external APIs change, mocked tests lie. Test how your adapter handles your internal contract, not how well you simulate the vendor.
- **Shallow UI checks:** Do not test CSS classes, DOM trees, or widget mounting. Test user-facing workflows and state transitions.
- **Deleted names and arbitrary negatives:** Do not test that an old name or flag is gone. Do not test random fake inputs (`--fake-flag`) just to watch them fail. Use a fake value only when testing a general parser rule (e.g. "unknown flags return code 2").
