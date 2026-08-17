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
- **Test what still happens, not what is gone.** A test that only
  checks “this name does not exist” is not useful. Clap, the type
  checker, or the router would fail a made-up name the same way.
  When you delete a flag, method, export, or route, write the red
  test for what callers still get (always-on stealth, a real error,
  one process). Do not write a test that the old name is missing.
- **A fake name is only a probe.** If the rule is “unknown input
  must fail like this,” one unused name can hit that branch. The
  test is about the rule. If the test is about one deleted name,
  delete the test.
