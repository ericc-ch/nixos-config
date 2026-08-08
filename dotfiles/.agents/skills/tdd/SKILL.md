---
name: tdd
description: Write features or fix bugs using test-driven development.
---

# Test-Driven Development

Build features using the red-green testing loop.

Read `CONTEXT.md` (if present) before writing tests to match domain terminology and project rules.

## The TDD Loop

1. **Red:** Write a small test for the behavior you want. Run it and confirm it fails.
2. **Green:** Write the minimum code needed to make the test pass.
3. **Clean up:** Refactor the code if needed, ensuring tests remain green.

---

## Testing Guidelines

- **Test public behavior:** Test what code does through public APIs or interfaces. Do not test private implementation details.
- **Agree on test boundaries:** Confirm with the user which public interfaces to test before writing tests.
- **Use independent expected values:** Hardcode expected output values from specs. Do not compute expected results using the same logic as the code under test.
- **One feature at a time:** Write one test, make it pass, and then move to the next.
