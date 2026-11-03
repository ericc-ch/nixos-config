---
name: code-conventions
description: "Strict, opinionated code conventions that override default coding-agent habits. Every rule is mandatory. Use for new or changed code, not throwaway prototypes."
---

Read the language reference before writing code:

- TypeScript: [references/typescript.md](references/typescript.md)
- Rust: [references/rust.md](references/rust.md)

## External References

- Shallow-clone every repository a language reference names into `/tmp/references/<name>` (`git clone --depth 1 <url>`). If it already exists, run `git pull --ff-only` instead.
- Read `/tmp/references/` before any web documentation. It is the source of truth.
- Never modify files in `/tmp/references/`.

## Principles

- Read untrusted input once, at the boundary that owns it. Never check again inside the domain for what a parser, constructor, or type already guarantees. Checking twice hides where the real boundary is.
- Every primitive that carries an invariant must be a branded type like `UserId` or `Cents`. A value with no invariant stays a primitive.
- Build domain types only through parsers. Never pass raw strings where domain types exist.
- Model every lifecycle as a tagged sum type. Each state holds only its own data.
- Handle closed unions exhaustively. Never add a default or wildcard branch.
- Every operation takes exactly one explicit input type.
- Never accept a partial input object, except in a partial-update operation.
- A boolean is only ever a pure predicate result like `isExpired(token)`. Never take a positional boolean parameter; group boolean options into a named object.
- Delete any code whose removal leaves visible behavior unchanged.
- Never bind a value that is read exactly once. Inline it.
- Never drop an edge case to make code shorter. A naive short version that skips edge cases is simplistic, not simple.
- Never silence a lint or compiler warning. Fix the design that triggers it.
- Never work around a dependency bug. Let it fail honestly and record the gap.
- Catch an error only to turn it into the typed error this layer promises, keeping the original cause, or to return a fallback that is a valid domain result. Never catch for any other reason.
- Never turn a failure into a success value. Never record a crash as a refusal or a final outcome.
- Every error message reads `<what>. <why>. Fix: <step>` and includes the rejected input or its location.
- Run every independent check before writing any output. Report all failures together. Write nothing unless all pass.
- Core logic never reads the clock, randomness, or I/O directly; inject them. Core logic is deterministic: the same inputs replay the same run.
- Module load has no side effects.
- Never use mutable singletons or hidden global state.

## Enforcement

- Every fix for a bug or bad pattern that can recur ships with a lint rule or check that fails on the old code, and fixes every existing instance. Write prose only when no check can catch it.
- Every state machine that owns a system's lifecycle, protocol, or main loop has a TLA+ model and its own formal-verification skill. Check the model before trusting the implementation.
- Every shipped artifact has a byte-size budget the build enforces. Never raise a budget to accept growth.

## Modules

- Never add an interface, trait, port, or layer that has one implementation. Add it when the second implementation arrives.
- Code that runs every frame or tick lives only in hot files (`*.hot.ts`, `*_hot.rs`). Hot code never allocates. The language reference names the check that enforces it.
- Define each port in the module of the service that calls it.
- Never add a second adapter for a backend an existing adapter already talks to. Make the existing adapter implement the new port.
- Never create forwarding-only adapters.
- Never create one repository per database table.
- An HTTP response is a success only after its status is checked and its body is decoded into a domain type, both inside the outbound adapter.

### Code Organization

- The main function reads as the happy path. Checks and supporting details go in helpers below it, named after what they handle (`requireConfig`, `readMetadata`).
- Never extract a helper that has one call site. The only exception is a check or supporting step moved out of a main function by the happy-path rule.
- A helper with several call sites must still name a meaningful operation, invariant, policy, transformation, or reusable algorithm. Otherwise inline it.
- Never create shallow helpers that only forward arguments, wrap a single call or operator, rename syntax, or hide a trivial expression. Keep code like `add(x, y) => x + y` or `useWrapper((x) => { useEffect(x) })` inline even if it appears more than once.
- Never extract a function whose name is longer or vaguer than the expression it hides. If you have to open the helper to know what it does, inline it:

  ```c
  // Bad: the name hides the operation and says nothing about byte order.
  #define make_u32_from_two_u16(hi, lo)  (((u32)(hi) << 16) | (u32)(lo))
  version = make_u32_from_two_u16(major, minor);

  // Good: the expression is the explanation.
  version = ((u32)major << 16) | (u32)minor;
  ```

- Every domain concept has exactly one representation.

## Sensitive Data

- Wrap API keys, tokens, and passwords in opaque redacted types at the boundary.
- Unwrap secret values only inside outbound adapters, right before the external call.

## Style

- Never write a type annotation the compiler can infer.
- Never use an unchecked type cast or any other trick that bypasses the type checker.
- Import names explicitly. Never wildcard-import.
- Never write a macro or metaprogramming where a function, generic, or trait expresses the same thing.
- Name files after what they do. Never create generic bags like `utils`, `helpers`, or `common`.

## Comments and Tests

- Write comments only as doc comments on exported functions, types, and modules. The one other allowed comment is the Rust `// SAFETY:` comment.
- A doc comment documents the full contract: what the function does, its invariants, every parameter, return value, errors it throws, and at least one example usage. A reader can call the function correctly without reading its body.
- Never write comments for internal implementation details, workarounds, or hacks. If code needs explaining, the fix is a better name or a test. Agents copy comments, so a comment that explains a workaround spreads the workaround.
- Never write vacuous comments. Never leave comments noting that something was removed, changed, or does not exist. If code is removed, delete it without comment.
- Write tests only when the user asks for them. Call a public boundary with a concrete input and assert the exact visible output. Example: `expect(slugify("Hello, World!")).toBe("hello-world")`.
- A rule that must hold for every input is tested with a property test, not examples.
- Production code serves production behavior, not tests. Never add test-only constructors, modes, backends, state accessors, or public exports. Tests adapt to the production architecture and exercise public boundaries.
- Use a test double only to implement a port the production design already needs. Never add a port or alternate implementation for a test alone.
- Never write mock-only, truthy-only, self-comparing, or constant-restating tests.
- Run the undefined check on every test file you write: stub imports to `undefined` and rerun the file. Keep tests that turn red. Rewrite or delete tests that stay green.
