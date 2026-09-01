---
name: code-conventions
description: "Applies typed errors, parse-at-boundary, hexagonal modules, and end-to-end tests when writing or refactoring production code. Use whenever new or changed production logic is being written. Skip for throwaway prototypes unless asked."
---

Standards for writing and refactoring code.

## Languages

Read the annex for your language before writing code in it:

- TypeScript: [typescript.md](references/typescript.md)

## Core principles

- Return **errors as values** for expected failures. Crash only on defects.
- **Parse, don't validate**. Turn untrusted input into typed values at boundaries.
- Make **illegal states unrepresentable**.
- Put pure logic in a functional core and side effects in an imperative shell. Design **deep modules** that hide complexity behind small interfaces.
- Prove behavior end to end through public boundaries. Never mock modules.

## Errors

Expected failures are values: Result, Either, a checked error channel, or a sum type, whichever fits the language. Domain, parsing, authorization, integration, I/O, database, configuration, and workflow failures all count. Callers handle the failure or pass it upward. Catch untyped failures from third-party code inside adapters and convert them there. The outermost boundary translates errors into valid outputs: HTTP status codes, CLI exit codes, retry decisions, dead letters, or startup messages. Reuse the project's error channel when one exists. Otherwise introduce a tagged result type.

Throwing, rejecting, and panicking share one mechanism. Reserve it for defects: a violated invariant, an impossible branch, an unimplemented path, or a catastrophic runtime failure. Route exhaustive-match fallthroughs through one shared "unreachable" helper. Configuration problems are values, not defects: report them safely and exit.

Expected failures carry one stable machine-readable discriminator (tag, subclass, or error code), a message formatted by the module that created the error, structured context fields, and an optional cause. Callers never identify errors by matching message strings. Keep error unions precise at module boundaries. Broad catch-all error types belong only at outer entrypoints and logging layers.

## Parse, don't validate

Boundary code converts raw input into typed domain models before inner code sees it. Parse at every boundary where external or stored data enters: requests, database reads, cache hits, RPC responses, queue events, workflow replays, deserialized state. Data that was valid at write time is not guaranteed valid at read time.

Name parsers after their job:

- `parseX(input): Result<X, ParseError>` parses untrusted input.
- `makeX(...)` or `createX(...)` builds a value from validated pieces.
- `isX(value)` tests a predicate.
- `assertX(...)` appears rarely, mainly in tests or framework glue.

Never name a function `validateX` if it returns a parsed value. Never pass wire shapes or schema-inferred types into core code; map them into named input types first (`CreateUserRequest`, `StripeCustomerResponse`), never with a `DTO` prefix. Schema libraries work as boundary parsers, not as validators scattered through business logic. Prefer the project's existing library; plain smart constructors work for small domain types.

## Domain modeling

Wrap raw primitives in domain types so IDs, units, and parsed strings cannot mix (`UserId`, `Cents`, `EmailAddress`, `PositiveInt`). Build them only through parsers or smart constructors. Never pass a raw string where a domain type exists. Do not hand a nullable value to a function that requires one; branch earlier instead. Define one explicit input type per operation; do not accept partial input bags unless partial updates are a real capability of the domain.

Model multi-state lifecycles as sum types, each state carrying only its own fields:

```txt
// Wrong: two booleans allow four states, three of them meaningless.
Invoice = { isSent: bool, isPaid: bool, sentAt: instant?, paidAt: instant? }

// Right: three states, each carrying only its own fields.
Invoice =
  | Draft { id: InvoiceId }
  | Sent  { id: InvoiceId, sentAt: Instant }
  | Paid  { id: InvoiceId, paidAt: Instant }
```

Handle closed unions exhaustively. Never add default branches that silently swallow unknown cases. Booleans fit pure predicates such as `isExpired(token)`. Do not pass boolean literals to control behavior, as in `createUser(input, true)`; group options into a named object instead.

## Modules and dependencies

Roles describe responsibilities, not folder structures. A role can be a function, object, class, file, or package. Do not add layers without need.

```txt
input -> inbound adapter -> application service -> domain module
                                 |
                                 +-> port -> outbound adapter -> external system
```

Dependencies point inward. Domain modules depend on nothing. Services depend on ports, never on concrete technology. Adapters implement ports and translate at the edges. An inbound adapter may call a domain module directly when the operation is pure and needs no authorization, policy, storage, or I/O.

Pick a role by asking what makes the code change:

| Changes because of                                    | Role                |
| ----------------------------------------------------- | ------------------- |
| Business rules, invariants, calculations, transitions | Domain Module       |
| Application policy, authorization, effect ordering    | Application Service |
| Frameworks, protocols, databases, external APIs       | Adapter             |
| Wiring, resource setup, configuration                 | Composition Root    |

Split code that has more than one reason to change. Do not split code just to fit the table.

### Domain Module

One main domain type with its rules: types, parsers, constructors, predicates, transitions, formatting. Pure and deterministic: no network calls, database access, permission checks, clocks, randomness, global state, or protocol formatting. If the module adds no protection against invalid state, use plain primitives instead.

### Application Service

One workflow, such as password reset. Applies application policy and coordinates side effects through narrow ports. Accepts and returns domain types with precise error unions. Receives dependencies, clocks, and randomness through injection. Stays independent of HTTP, CLI, database, and SDK types. Split a service whose methods need unrelated dependencies.

### Adapters

Inbound adapters (routes, CLI commands, queue consumers) parse external input into domain types, call the service, and format output. Parse identity and credentials here; the service checks authorization before acting. Outbound adapters (stores, API clients) implement ports, convert rows and SDK types into domain models and typed errors, and may retry brief safe network failures. Raw database and SDK types stay inside the adapter.

A port states what the application needs; an adapter provides it. Define each port beside the service that consumes it, in domain types, at the smallest size the service requires. One wide adapter can serve several narrow ports. Before adding an adapter, try reusing one as-is, then extending one that fits; create a new one only when nothing fits. Do not create adapters that only forward calls. Do not create one repository per table by default.

### Composition Root

Parses configuration, creates resources, initializes adapters, and injects them into services.

### Cohesion

Apply the deletion test: deleting a deep module removes complexity from the system; deleting a shallow module scatters its work across callers.

- Inline simple logic until reuse or complexity earns a helper. One call site is not reuse.
- Do not duplicate logic across files. Fix the existing source instead.
- Keep one shape per concept. Do not fork raw, summary, and display variants unless a contract requires them.

## Workflows, transactions, and idempotency

Durable workflows or sagas earn their cost only when operations must survive crashes, span long delays, wait for human approval, or coordinate several services. Short retries do not qualify.

Adapters retry brief network failures. Services decide whether to retry application steps. Never hold a transaction open across a network call or another long operation. Retryable state changes carry idempotency protection: idempotency keys, unique constraints, dedup records, state-machine guards, or inbox and outbox tables.

## Sensitive data and observability

Trace end to end across requests, jobs, workflows, modules, adapters, and external calls. Traces and logs carry safe diagnostic fields: domain IDs, operation names, state tags, retry counts, error discriminators. Never put secrets in errors, traces, logs, or test snapshots.

Wrap sensitive values (API keys, tokens, passwords) in an opaque redacted wrapper at the boundary. Unwrap only inside adapters, immediately before the external call.

## Configuration and lifecycle

Parse environment variables once at startup into a typed configuration value. Report misconfiguration safely and exit. Modules perform no side effects at load time: never open connections or start work on import. Acquire and release resources explicitly in startup and teardown code. Avoid mutable singletons and hidden globals. Inject clocks and randomness explicitly.

## Style

- Turn on the strictest practical static checking and treat findings as errors.
- Default to immutable data. Local mutation inside loops and builders is fine while callers cannot see it.
- Avoid unchecked casts and dynamic top-typed values.
- Export only the public API. Never export internals just for tests.
- Import from the defining module so call sites read clearly, as in `EmailAddress.parse(x)`.
- Give files descriptive names. Do not create junk drawers named `utils`, `helpers`, or `common`. A small shared module for ubiquitous helpers (result types, unreachable, redaction) is fine. Split files by reasons to change, never by line count.

## Comments

Prefer none. Names, types, and assertion messages carry meaning: `assert(ok, 'persisted across restart')`, not `// check persistence`.

Allowed: legal or license headers; behavior forced by an external dependency, platform, vendor, or protocol this codebase cannot reshape; `// prettier-ignore`; lint or type suppressions only when the rule is faulty, pedantic, or style-only; doc comments that define a public API contract; issue or RFC links for a constraint code cannot express.

If unsure a keep clause applies, omit the comment. Surprises in our own code are not a keep clause: rename, extract, type, or restructure until the behavior is obvious. IMPORTANT, do not remove, fine for now, and long justifications are not reasons to keep a comment.

## Testing

An end-to-end test drives the outermost boundary the code exposes, whatever kind it is: a CLI command, an HTTP endpoint, a queue consumer, or the exported API of a library package. Tests always enter through a public boundary. Tests that import internals are banned, whatever they call themselves.

Write one failing end-to-end test, confirm it fails, write the minimum code to pass, refactor green. Never write production code with no failing test demanding it. Inject fakes for external systems such as payments and email. Never mock modules. Build fixtures through parsers and respect domain invariants. No test-only flags or exports.

Prove the result on the real surface: run the feature, read the actual output, screenshot UI work. A clean build is not evidence. Performance claims need a measured baseline and a post-fix number; never read source instead of measuring.

When behavior changes, update the tests. An end-to-end test that breaks during an internal refactor caught a behavior change; fix one or the other.

Delete on sight:

- Trivial glue tests and existence checks.
- Anything the type system already guarantees.
- Deep third-party mocks that mimic vendor shapes. They lie when vendors change.
- Shallow UI checks such as CSS classes and mount booleans. Test user-visible workflows instead.
- Tests of deleted names and fake-input negatives with no rule behind them.
