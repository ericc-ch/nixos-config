---
name: code-conventions
description: "Enforces code conventions and best practices for any programming language / code. Use for new or changed code, not throwaway prototypes."
---

Read the language reference before writing code:

- TypeScript: [references/typescript.md](references/typescript.md)
- Rust: [references/rust.md](references/rust.md)

## External References

- Sync external repositories into `/tmp/references/` with the template script [scripts/references.py](scripts/references.py): copy it somewhere, fill in its `REPOSITORIES` list, and run `python3 scripts/references.py`.
- Read `/tmp/references/` as the primary source of truth before searching web documentation.
- Never modify files in `/tmp/references/`.

## Principles

- Parse untrusted input at boundaries into domain types.
- Read untrusted input once, at the boundary that owns it. Do not check again inside the domain for what a parser, constructor, or type already guarantees. Checking twice hides where the real boundary is.
- Wrap raw primitives in branded types like `UserId` and `Cents`.
- Build domain types only through parsers. Never pass raw strings where domain types exist.
- Never pass nullable values to functions that require a value. Branch before calling.
- Design types so invalid states cannot exist.
- Model lifecycles with tagged sum types. Each state holds only its own data.
- Handle closed unions exhaustively. Never add a default branch that silently ignores unknown cases.
- Define one explicit input type per operation.
- Do not accept partial input objects unless the operation is a partial update.
- Use booleans only as pure predicates like `isExpired(token)`. Group boolean options into named objects.
- Leave less code behind. Delete code when visible behavior stays the same.
- Inline a value that is read only once.
- Simplicity is not brevity. A naive short version that skips edge cases is simplistic, not simple.
- Prefer the obvious version over the clever one, even when it takes more lines. More code and larger changes are fine when they make behavior clear or remove invalid states.
- Prefer a standard-library abstraction over a same-contract custom one.
- Never silence a lint or compiler warning. Fix the design that triggers it.
- When code fights you, fix the design instead of patching around it.
- Let a dependency bug fail honestly. Record the gap; do not build a workaround.
- Do not catch an error when the caller cannot act on it. Catch only to turn a failure into the typed error this layer promises, and keep the original cause.

## Modules

- Keep dependencies pointing inward toward domain logic.
- Split files when reasons to change diverge, not when line count grows.
- A good module hides a lot of work behind a small interface. Callers get real behavior from a few simple calls instead of chaining many small pieces themselves.
- Do not add a layer for a second implementation that does not exist yet. With one implementation, the layer is a guess. Inline it and add the layer when the second implementation arrives.

### Module Roles

- Domain module: Holds one entity, its parsers, predicates, and state transitions. Pure logic only. No network calls, database queries, clocks, randomness, or permissions. If a domain type adds no invariants, use a primitive.
- Application service: Coordinates one business workflow, like password reset. Calls outbound ports. Receives clocks, randomness, and dependencies via injection. Contains no HTTP, CLI, database, or SDK types.
- Inbound adapter: HTTP routes, CLI commands, queue consumers. Parses raw input into domain types, calls application services, and formats responses. Handles auth credentials at this layer.
- Outbound adapter: Database stores, HTTP clients, message publishers. Implements ports defined by services. Converts database records and SDK types into domain models and typed errors.
- Composition root: Application startup. Reads configuration, builds instances, wires dependencies, and starts services.

### Boundaries and Ports

- Define each port beside the service that calls it.
- Keep ports minimal. Include only the methods that the calling service needs.
- Let one outbound adapter implement multiple small ports.
- Reuse an existing adapter before extending or creating a new one.
- Do not create forwarding-only adapters.
- Do not create one repository per database table.

### Code Organization

- Write the main function as the happy path. Move checks and supporting details into helpers below it, named after what they handle (`requireConfig`, `readMetadata`).
- Do not extract a helper that has one call site. Keep that logic inline.
- Multiple call sites are necessary but not sufficient to justify a helper. Extract only when the helper represents a meaningful operation, invariant, policy, transformation, or reusable algorithm.
- Do not create shallow helpers that only forward arguments, wrap a single call or operator, rename syntax, or hide a trivial expression. Keep code like `add(x, y) => x + y` or `useWrapper((x) => { useEffect(x) })` inline even if it appears more than once.
- Do not extract a function when the extraction hurts readability. A helper name that is longer or vaguer than the expression it hides makes call sites harder to read, not easier. If you have to open the helper to know what it does, inline it:

  ```c
  // Bad: the name hides the operation and says nothing about byte order.
  #define make_u32_from_two_u16(hi, lo)  (((u32)(hi) << 16) | (u32)(lo))
  version = make_u32_from_two_u16(major, minor);

  // Good: the expression is the explanation.
  version = ((u32)major << 16) | (u32)minor;
  ```

- Keep one representation per domain concept.

## Effects and Lifecycle

- Parse all configuration at startup into typed structures. Exit immediately on invalid configuration.
- Keep module load time free of side effects.
- Manage resource acquisition and release explicitly in startup and shutdown logic.
- Do not use mutable singletons or hidden global state.
- Inject clocks, randomness, and I/O explicitly.

## Sensitive Data

- Wrap API keys, tokens, and passwords in opaque redacted types at the boundary.
- Unwrap secret values only inside outbound adapters right before the external call.
- Pass only safe fields in logs and traces: domain IDs, operation names, state tags, error tags.
- Never write secrets to logs, traces, or error objects.

## Style

- Enable strict compiler checks and treat all warnings as errors.
- Default to immutable data structures. Local mutation inside loops or builders is fine if hidden from callers.
- Prefer type inference. Add explicit types/annotations only when the compiler cannot infer them.
- Do not use unchecked type casts or other tricks that bypass the type checker.
- Export only the public interface.
- Import names explicitly. Never wildcard-import.
- Prefer plain language constructs over macros or metaprogramming.
- Name files after what they do. Avoid generic bags like `utils`, `helpers`, or `common`.

## Comments and Tests

- Only write comments for public-facing interfaces and APIs (for example, JSDoc or docstrings on exported functions, types, and modules).
- Public comments should be detailed. Document the full contract: what the function does, its invariants, every parameter, return value, errors it throws, and at least one example usage. A reader should be able to call the function correctly without reading its body.
- Never write comments for internal implementation details, workarounds, or hacks. Do not use comments to explain away bad code or a workaround. Fix the design or write self-explanatory code instead.
- Never write vacuous comments. Do not leave comments noting that something was removed, changed, or does not exist. If code is removed, delete it without comment.
- Only write tests when the user asks for them. Call a public boundary with a concrete input and assert the exact visible output. Example: `expect(slugify("Hello, World!")).toBe("hello-world")`.
- Production code must serve production behavior, not tests. Do not add test-only constructors, modes, backends, state accessors, or public exports. Tests adapt to the production architecture and exercise public boundaries.
- Use a test double only to implement a port the production design already needs. Do not add a port or alternate implementation for a test alone.
- If a test needs internal access or bypasses the production lifecycle, move the test to the public boundary or remove it. Do not weaken the production design to keep a test.
- Skip mock-only, truthy-only, self-comparing, or constant-restating tests.
- Undefined check: stub imports to `undefined`, rerun the file. Keep tests that turn red. Rewrite or delete tests that stay green.
