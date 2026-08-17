# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Gone-name tests**: The test only checks that a name is missing.
The parser already rejects names it does not know.

```typescript
// BAD: --workers is gone, so clap fails. It would also fail --not-a-real-flag.
test("serve rejects --workers", () => {
  expect(parse(["serve", "--workers", "4"]).ok).toBe(false);
});

// BAD: checks that an old function is not exported
test("lib does not export stealth()", () => {
  expect("stealth" in api).toBe(false);
});

// GOOD: after removing opt-out, stealth is still on
test("scripted fetch uses the stealth user agent", async () => {
  const ua = await capturedUserAgent();
  expect(ua).toMatch(/Chrome\/145/);
});

// GOOD: unknown Page methods must error, not return {}
test("unknown Page methods error instead of returning {}", async () => {
  const err = await cdp("Page.notARealMethod", {});
  expect(err.message).toMatch(/Unknown Page method/);
});
```

Warning signs:

- The test would still pass if you swapped in a nonsense name
- The test name is “X is rejected,” “X is gone,” “X is not exported,”
  or “help does not mention X”
- A cleanup whose only new test is that the old API is missing

**Tautological tests**: Expected value restates the implementation, so the test passes by construction.

```typescript
// BAD: Expected value is recomputed the way the code computes it
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD: Expected value is an independent, known literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
