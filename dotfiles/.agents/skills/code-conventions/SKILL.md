---
name: code-conventions
description: "Applies typed errors, parse-at-boundary, and hexagonal modules when writing or refactoring production code. Use whenever new or changed production logic is being written. Skip for throwaway prototypes unless asked."
---

Read the language reference before writing code:
- TypeScript: [references/typescript.md](references/typescript.md)

## Principles

- Parse untrusted input at boundaries into domain types.
- Wrap raw primitives in branded types like `UserId` and `Cents`.
- Build domain types only through parsers. Never pass raw strings where domain types exist.
- Never pass nullable values to functions that require a value. Branch before calling.
- Make illegal states unrepresentable.
- Model lifecycles with tagged sum types. Each state holds only its own data.
- Handle closed unions exhaustively. Never add default branches that swallow unknown cases.
- Define one explicit input type per operation.
- Do not accept partial input objects unless the operation is a partial update.
- Use booleans only as pure predicates like `isExpired(token)`. Group boolean options into named objects.

## Modules

- Keep dependencies pointing inward toward domain logic.
- Split files when reasons to change diverge, not when line count grows.

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

- Inline logic until reuse or complexity justifies a helper. One call site is not reuse.
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
- Do not use unchecked type casts or dynamic escape hatches.
- Export only the public interface.
- Name files after what they do. Avoid generic bags like `utils`, `helpers`, or `common`.

## Comments and Tests

- Never write comments unless the user asked for them.
- If a comment would help, propose it first. Add it only after the user agrees.
- Never write tests unless the user asked for them.
- When tests are requested, write only end-to-end tests that exercise a public boundary.
- Do not write unit tests or tests of small internal modules. Propose those instead.
