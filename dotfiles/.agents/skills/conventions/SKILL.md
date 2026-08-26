---
name: conventions
description: Correct-by-construction coding standards for any language. Covers typed errors, parsing at boundaries, hexagonal modules, and mock-free testing. Use when writing or refactoring production code.
---

# Code Conventions

Standards for writing and refactoring code in any language. Apply them to new code and refactored logic. Follow existing project patterns only when they match these standards.

When you write TypeScript, also read [typescript.md](typescript.md) in this directory.

## Scope and precedence

Inspect the repository before you add a pattern, library, or abstraction. Check how existing code handles errors, input parsing, dependency injection, testing, observability, and module layout. Reuse what fits. Stop incompatible patterns at the nearest boundary instead of copying them inward.

Apply these standards without triggering broad rewrites. Introduce them in new or refactored code and convert at boundaries. Preserve existing logging, tracing, and metrics hooks.

When rules conflict:

1. Preserve correctness, safety, and debuggability.
2. Apply these standards to new and refactored logic.
3. Follow compatible project architecture and conventions.
4. Leave unrelated existing code alone unless asked.
5. Document trade-offs in comments or ADRs.

## Core principles

- Return **errors as values** for expected failures. Crash only on defects.
- **Parse, don't validate**. Turn untrusted input into typed values at boundaries.
- Make **illegal states unrepresentable**. Make invalid data unconstructable.
- Prefer **composition over inheritance**. Put pure logic in a functional core and side effects in an imperative shell.
- Design **deep modules** that hide complexity behind small interfaces (see the `codebase-design` skill).
- Test behavior through public boundaries with fakes. Never mock modules.

## Errors

### Expected failures are values

Functions return known failures as typed values. Use Result, Either, a checked error channel, or a sum type, whichever fits the language. Callers handle the failure or pass it upward. Domain, parsing, authorization, integration, I/O, database, configuration, and workflow failures all count as expected failures.

Throwing, rejecting, and panicking share one mechanism. Reserve that mechanism for defects. Catch untyped failures from third-party code inside adapters and convert them to typed errors there.

The outermost boundary translates errors into valid outputs: HTTP status codes, CLI exit codes, retry decisions, dead letters, or startup messages. Reuse the project's error channel when one exists. Otherwise introduce a tagged result type.

### Defects may crash

Code may throw or panic only when a defect makes correct execution impossible: a violated invariant, an impossible branch, an unimplemented path, or a catastrophic runtime failure. Route exhaustive-match fallthroughs through one shared "unreachable" helper. Configuration problems are values, not defects. Report them safely and exit.

### Error identity

Expected failures carry:

- One stable machine-readable discriminator: a tag field, an exception subclass, or an error code.
- A message formatted by the module that created the error. Outer callers may add context.
- Structured context fields and an optional cause.

Callers never identify errors by matching message strings. Keep error unions precise at module boundaries. Broad catch-all error types belong only at outer entrypoints and at logging layers.

## Parse, don't validate

Boundary code converts raw input into typed domain models before inner code sees it. Parse at every boundary where external or stored data enters: requests, database reads, cache hits, RPC responses, queue events, workflow replays, deserialized state. Data that was valid at write time is not guaranteed valid at read time.

Name parsers after their job:

- `parseX(input): Result<X, ParseError>` parses untrusted input.
- `makeX(...)` or `createX(...)` builds a value from validated pieces.
- `isX(value)` tests a predicate.
- `assertX(...)` appears rarely, mainly in tests or framework glue.

Never name a function `validateX` if it returns a parsed value. Never pass wire shapes or schema-inferred types into core code. Map them into named input types first. Name those types after their purpose (`CreateUserRequest`, `StripeCustomerResponse`), never with a `DTO` prefix. When no transformation is needed, parse straight into the input type.

Schema libraries work as boundary parsers, not as validators scattered through business logic. Prefer the project's existing library. For small domain types, plain smart constructors work too. Parsing produces refined domain types and typed errors.

## Domain modeling

### Domain types over raw primitives

Wrap raw primitives in domain types so IDs, units, and parsed strings cannot mix (`UserId`, `Cents`, `EmailAddress`, `PositiveInt`). Use whatever the language affords: branded types, newtypes, or single-field records. Build them only through parsers or smart constructors. Never pass a raw string where a domain type exists.

Do not hand a nullable value to a function that requires one. Branch earlier instead. Do not accept partial input bags unless partial updates are a real capability of the domain. Define one explicit input type per operation.

### Sum types over boolean flags

Model multi-state lifecycles as sum types: tagged unions, sealed enums, or variant records. Each state carries only its own fields. Do not track state with independent boolean flags plus optional timestamps:

```txt
// Wrong: two booleans allow four states, three of them meaningless.
Invoice = { isSent: bool, isPaid: bool, sentAt: instant?, paidAt: instant? }

// Right: three states, each carrying only its own fields.
Invoice =
  | Draft { id: InvoiceId }
  | Sent  { id: InvoiceId, sentAt: Instant }
  | Paid  { id: InvoiceId, paidAt: Instant }
```

Handle closed unions exhaustively. Never add default branches that silently swallow unknown cases.

Booleans fit pure predicates such as `isExpired(token)`. Do not pass boolean literals to control behavior, as in `createUser(input, true)`. Group options into a named object instead. Put primary inputs in positional parameters and extras in that object.

## Modules and dependencies

Roles describe responsibilities, not folder structures. A role can be a function, object, class, file, or package. Do not add layers without need.

Data flows one way:

```txt
input -> inbound adapter -> application service -> domain module
                                 |
                                 +-> port -> outbound adapter -> external system
```

An inbound adapter may call a domain module directly when the operation is pure and needs no authorization, policy, storage, or I/O. Dependencies point inward. Domain modules depend on nothing. Services depend on ports, never on concrete technology. Adapters implement ports and translate at the edges.

Pick a role by asking what makes the code change:

| Changes because of                                    | Role                |
| ----------------------------------------------------- | ------------------- |
| Business rules, invariants, calculations, transitions | Domain Module       |
| Application policy, authorization, effect ordering    | Application Service |
| Frameworks, protocols, databases, external APIs       | Adapter             |
| Wiring, resource setup, configuration                 | Composition Root    |

Split code that has more than one reason to change. Do not split code just to fit the table.

### Domain Module

A domain module groups one main domain type with its rules: types, parsers, constructors, predicates, transitions, and formatting functions. It stays pure and deterministic. No network calls, database access, permission checks, clocks, randomness, global state, or protocol formatting. Parsers return refined types. Expected failures come back as values. If the module adds no protection against invalid state, use plain primitives instead. Classes and value objects follow the same rules: construct through builders, keep fields immutable, avoid side effects, avoid inheritance for domain behavior.

### Application Service

An application service manages one workflow, such as password reset. It applies application policy and coordinates side effects through narrow ports. Services accept and return domain types with precise error unions. They receive dependencies, clocks, and randomness through injection. Services stay independent of HTTP, CLI, database, and SDK types. Do not parse requests, render responses, run queries, or touch concrete technology inside a service. Split a service whose methods need unrelated dependencies.

### Adapters

Inbound adapters (routes, CLI commands, queue consumers) parse external input into domain types, call the service, and format output. Inbound adapters stay thin. No business rules live here. Parse identity and credentials here; the service checks authorization before acting.

Outbound adapters (stores, API clients) implement ports. They convert rows and SDK types into domain models and typed errors. Raw database and SDK types stay inside the adapter. An adapter may retry brief safe network failures. Adapters contain no business rules and decide no workflow order.

A port states what the application needs. An adapter provides it. Define each port beside the service that consumes it, in domain types, at the smallest size the service requires. One wide adapter can serve several narrow ports. Do not create adapters that only forward calls. Before adding an adapter, try reusing one as-is, then extending one that fits. Create a new one only when nothing fits. Write an ADR only when introducing a new shared architectural boundary or a major provider strategy.

Persistence follows the same rules. Do not create one repository per table by default. Store adapters return domain types and typed errors. Queries, ORM models, and rows stay hidden inside.

### Composition Root

The composition root parses configuration, creates resources, initializes adapters, and injects them into services. Business logic lives elsewhere.

### Cohesion

Apply the deletion test: deleting a deep module removes complexity from the system. Deleting a shallow module scatters its work across callers.

- Inline simple logic until reuse or complexity earns a helper.
- Do not duplicate logic across files. Fix the existing source instead.
- Keep one shape per concept. Do not fork raw, summary, and display variants unless a contract requires them.
- UI components own display logic. Services produce state; views render it.

## Workflows, transactions, and idempotency

Single operations need plain calls or one transaction. Durable workflows or sagas earn their cost only when operations must survive crashes, span long delays, wait for human approval, or coordinate several services. Short retries do not qualify.

Adapters retry brief network failures. Services decide whether to retry application steps. Durable workflows persist retries across restarts. Never hold a transaction open across a network call or another long operation. Retryable state changes carry idempotency protection: idempotency keys, unique constraints, dedup records, state-machine guards, or inbox and outbox tables.

## Sensitive data and observability

Trace end to end across requests, jobs, workflows, modules, adapters, and external calls. Traces and logs include safe diagnostic fields: domain IDs, operation names, provider names, state tags, retry counts, error discriminators, and safe summaries. Never put secrets in errors, traces, logs, or test snapshots.

Wrap sensitive values such as API keys, tokens, and passwords in an opaque redacted wrapper at the boundary. Keep them wrapped through application code. Unwrap them only inside adapters, immediately before the external call.

## Configuration and lifecycle

Parse environment variables once at startup into a typed configuration value. Report misconfiguration safely and exit. Do not read ambient config scattered through the codebase.

Modules perform no side effects at load time. Never open connections or start work on import. Acquire and release resources explicitly in startup and teardown code, or through the framework lifecycle. Avoid mutable singletons and hidden globals. Inject clocks and randomness explicitly.

## Style

- Turn on the strictest practical static checking: compiler modes and linters. Treat findings as errors.
- Default to immutable data. Local mutation inside loops and builders is fine while callers cannot see it.
- Avoid unchecked casts, dynamic top-typed values, and null-forgiving operators. When one is truly unavoidable, leave a `SAFETY:` comment stating why the invariant holds.
- Export only the public API. Never export internals just for tests.
- Import from the defining module so call sites read clearly, as in `EmailAddress.parse(x)`. Do not create barrel files whose only job is re-exporting.
- Give files descriptive names. Do not create junk drawers named `utils`, `helpers`, or `common`. A small shared module for ubiquitous helpers (result types, unreachable, redaction) is fine. Split files by reasons to change, never by line count.
- Write doc comments on exported symbols in the standard format of the language. Cover intent, parameters, and returns including error results. Document true crashes as throws or panics. Do not document expected typed errors as throws. Comments explain invariants and trade-offs. Skip the obvious.

## Testing

Use the `tdd` skill for the loop and for test-level priorities.

- Assert observable outcomes: returned values and errors, persisted records, emitted events, and messages captured by fakes. Do not assert on implementation details.
- Replace module mocks and spies with injected fakes: fake adapters, in-memory stores, throwaway local databases. A spy assertion is acceptable only when the side effect is the sole output.
- Do not test what the type system already guarantees. Do not add test-only flags or exports to production code. Fixtures go through parsers and respect domain invariants.
- Property-test parsers, constructors, state machines, serializers, and idempotent functions with the project's property-testing library. Co-locate generators with the module they test.
- Add compile-time tests for heavily generic APIs so inference regressions surface early.
- Update tests when behavior changes. Delete tests that an internal refactor breaks without a behavior change.
