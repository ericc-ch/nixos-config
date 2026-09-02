---
name: code-conventions
description: "Applies typed errors, parse-at-boundary, and hexagonal modules when writing or refactoring production code. Use whenever new or changed production logic is being written. Skip for throwaway prototypes unless asked."
---

Read the language annex before writing code in it: TypeScript → [typescript.md](references/typescript.md).

## Principles

Parse untrusted input into typed values at boundaries. Wrap raw primitives in domain types (`UserId`, `Cents`) and build them only through parsers. Never pass a raw string where a domain type exists. Never hand a nullable to a function that needs a value; branch earlier instead.

Make illegal states unrepresentable. Model lifecycles as sum types with one variant per state. Each state carries only its own fields. Handle closed unions exhaustively. Never add default branches that swallow unknown cases.

Define one explicit input type per operation. Do not accept partial input bags unless partial updates are a real capability. Use booleans only as pure predicates like `isExpired(token)`. Never pass boolean literals to control behavior; group options into a named object.

Put pure logic in a functional core and side effects in an imperative shell. Design deep modules that hide complexity behind small interfaces.

## Modules

Roles are responsibilities, not folder structures. Do not add layers without need. Dependencies point inward. What makes the code change picks the role:

- Business rules, invariants, calculations, transitions → domain module.
- Application policy, authorization, effect ordering → application service.
- Frameworks, protocols, databases, external APIs → adapter.
- Wiring, resource setup, configuration → composition root.

Split code that has more than one reason to change. Do not split it just to fill the list above.

A domain module holds one main type with its rules: parsers, predicates, transitions. It is pure. No network calls, database access, clocks, randomness, or permission checks. If it adds no protection against invalid state, use plain primitives instead.

An application service runs one workflow, such as password reset. It coordinates side effects through narrow ports defined beside it, in domain types, with precise error unions. The service receives dependencies, clocks, and randomness through injection and stays independent of HTTP, CLI, database, and SDK types. Split a service whose methods need unrelated dependencies.

Inbound adapters (routes, CLI commands, queue consumers) parse external input into domain types, call the service, and format output. Parse identity and credentials here. The service checks authorization before acting. An inbound adapter may call a domain module directly when the operation is pure and needs no authorization, policy, storage, or I/O.

Outbound adapters (stores, API clients) implement ports. They convert rows and SDK types into domain models and typed errors. Raw database and SDK types stay inside the adapter. Outbound adapters may retry brief safe network failures.

A port states what the application needs. An adapter provides it. Define each port beside the service that consumes it, at the smallest size the service requires. One wide adapter can serve several narrow ports. Reuse an adapter as-is first, then extend one that fits, and create a new one only when nothing fits. Do not create forwarding-only adapters or one repository per table.

Run the deletion test. Deleting a deep module removes complexity from the system. Deleting a shallow module scatters its work across callers. Inline simple logic until reuse or complexity earns a helper. One call site is not reuse. Do not duplicate logic across files; fix the existing source instead. Keep one shape per concept.

## Effects and lifecycle

Use durable workflows or sagas only when operations must survive crashes, span long delays, wait for human approval, or coordinate several services. Short retries do not qualify.

Adapters retry brief network failures. Services decide whether to retry application steps. Never hold a transaction open across a network call or another long operation. Protect retryable state changes with idempotency keys, unique constraints, state guards, or inbox and outbox tables.

Parse configuration once at startup into a typed value. Report misconfiguration safely and exit. Modules perform no side effects at load time. Acquire and release resources explicitly in startup and teardown code. Avoid mutable singletons and hidden globals. Inject clocks and randomness explicitly.

## Sensitive data

Wrap API keys, tokens, and passwords in an opaque redacted wrapper at the boundary. Unwrap them only inside adapters, immediately before the external call.

Trace end to end across requests, jobs, workflows, modules, adapters, and external calls. Logs and traces carry safe fields only: domain IDs, operation names, state tags, retry counts, error discriminators. Never put secrets in errors, traces, or logs.

## Style

Turn on the strictest practical static checking and treat findings as errors. Default to immutable data. Local mutation inside loops and builders is fine while callers cannot see it. Avoid unchecked casts and dynamic top-typed values.

Export only the public API. Import from the defining module so call sites read clearly, as in `EmailAddress.parse(x)`.

Give files descriptive names. Do not create junk drawers named `utils`, `helpers`, or `common`; a small shared module for ubiquitous helpers (result types, unreachable, redaction) is fine. Split files by reasons to change, never by line count.

## Comments and tests

Never write comments. Never write tests.
