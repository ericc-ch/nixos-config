---
name: code-conventions
description: Correct-by-construction TypeScript standards. Use for TypeScript engineering or when another skill needs code conventions.
---

Follow these standards when writing or refactoring TypeScript code in this codebase.

- Inspect existing code before adding new patterns, libraries, adapters, or abstractions.
- Apply these standards to all new code and refactored logic.
- Follow existing project patterns ONLY IF they match these standards.

## Decision priority

When rules conflict, apply priorities in this order:

1. Preserve correctness, safety, and debuggability.
2. Apply these standards to all new code and refactored logic.
3. Follow compatible project architecture and conventions.
4. Stop incompatible existing patterns at the nearest boundary instead of copying them into new code.
5. Avoid changing unrelated existing code unless requested.
6. Document trade-offs using comments or ADRs.

## Core principles

- Return **errors as values** instead of throwing exceptions or rejecting promises for expected failures.
- **Parse don't validate**. Parse untrusted input early into typed values near entry boundaries. Do not validate and discard the type information.
- Make **illegal states unrepresentable** in types where practical.
- Prefer **correct-by-construction** APIs over convention-based checks.
- Use branded or domain types to prevent mistakes like mixing IDs or units.
- Prefer **composition over inheritance**.
- Prefer **imperative shell / functional core**.
- Design **deep modules with simple caller interfaces**.
- Test behavior through real integration seams; **avoid** module mocks and spy-driven tests.
- Keep code clear and discoverable.

## Adapting to existing codebases

Inspect the repository before adding a new pattern or library. Check existing choices for:

- Error handling
- Schema parsing
- Dependency injection
- Testing
- Observability and logging
- Adapters and services
- File and module layout

Apply these standards to all new code and refactored logic. Do not keep weak patterns just for consistency.

If existing code uses thrown exceptions, do not rewrite the whole codebase. Return typed error values in new or refactored code, then convert them at the system boundary for the existing framework. Preserve existing logging, tracing, metrics, and error hooks.

## Errors and failures

### Expected failures are values

Functions MUST return known failures as typed error values, even if the immediate caller cannot recover. Callers MUST handle the error or return it upward.

Outermost boundaries MUST translate errors into valid responses, such as:
- HTTP status codes
- CLI exit codes
- Retry decisions
- Dead letters
- Startup error messages

Known failures include domain, parsing, authorization, integration, I/O, database, configuration, and workflow errors.

Use error return types in this order:

1. Effect, if the codebase already uses Effect.
2. `better-result`, if available and appropriate.
3. A local tagged union:

```ts
type Result<T, E extends Error> =
  | { readonly _tag: "ok"; readonly value: T }
  | { readonly _tag: "err"; readonly error: E };
```

Prefer returning a Result type:

```ts
Promise<Result<User, UserLookupError>>;
```

Do NOT reject promises for ordinary failures:

```ts
Promise<User>; // Rejects for ordinary lookup or storage failures
```

Promise rejection is equivalent to throwing exceptions. Catch unhandled third-party promise rejections inside adapters and turn them into typed tagged errors. Rejections MAY only escape application code if a defect occurs.

### Defects may throw or panic

Code MAY throw an exception or panic ONLY when a defect makes correct execution impossible. Defects include:

- Violated internal invariants
- Impossible logic branches
- Unimplemented code paths (`notYetImplemented`)
- Catastrophic runtime failures

Configuration failures are values, not defects. The startup root MUST report configuration failures safely and exit.

Use shared panic helpers where available:

```ts
export function casesHandled(unexpectedCase: never): never;
export function shouldNeverHappen(msg?: string): never;
export function notYetImplemented(msg?: string): never;
```

Use `casesHandled` for switch or union checks. Avoid creating custom helpers if these exist.

### Custom errors

Expected failures MUST use custom tagged errors extending `Error`, `TaggedError` (from `better-result`), or `Schema.TaggedErrorClass` (in Effect).

Custom errors SHOULD include:

- A stable `_tag` property with `as const`
- A clear error message
- Structured context fields
- Safe telemetry fields
- An optional `cause: unknown`

The module that creates an error MUST format its message. Outer callers MAY add context or convert the error, but MUST NOT match error message strings to identify errors.

Example:

```ts
export class UserStoreUnavailable extends Error {
  readonly _tag = "UserStoreUnavailable" as const;

  constructor(
    readonly operation: "findActiveByEmail",
    readonly provider: "postgres",
    readonly cause: unknown,
  ) {
    super(`User store unavailable during ${operation}`);
  }
}
```

Keep error unions precise at module boundaries:

```ts
Result<User, UserNotFound | UserStoreUnavailable>;
```

Do NOT use broad generic error types like `AppError` except at outer entrypoints, logging, or rendering layers.

## Effect conventions

If the project uses Effect, follow these rules:

- **Business Logic vs Pipeline**: Use `Effect.gen` and `yield*` for business logic (handling dependencies, conditionals, multi-step sequential tasks). Use `.pipe` for composition, simple data transforms, error handling, tracing, and layer building. You MAY combine both.
- **Function Definitions**: Use `Effect.fn` for functions that return an effect. Do NOT return `Effect.gen(...)` from a plain function.
- **Handler Placement**: Do NOT call `.pipe` directly on `Effect.fn`. Pass handlers (`Effect.catch`, `Effect.ensuring`) as extra arguments to `Effect.fn`.
- **Sequential Flow**: Do NOT chain `.map`, `.flatMap`, or `.andThen` for sequential logic. Write sequential steps inside `Effect.gen`.
- **Separation of Concerns**: Keep business logic inside `Effect.gen`. Place cross-cutting concerns outside using `.pipe` or `Effect.fn` arguments.

## Sensitive data, telemetry, and debugging

Use end-to-end structured tracing across requests, background jobs, workflows, application modules, adapters, and external calls.

Traces and logs MUST include safe fields to diagnose failures:

- Domain IDs
- Operation names
- Provider names
- State tags
- Retry counts
- Typed error tags
- Safe summaries

Do NOT include secrets in errors, traces, logs, or test snapshots.

Use a `Redacted<T>` wrapper for sensitive values like API keys, tokens, passwords, and secrets. Use Effect's `Redacted.Redacted` or a shared `Redacted<T>` wrapper.

Wrap sensitive values at the system boundary. Keep them redacted through application code. Unwrap sensitive values ONLY inside adapters immediately before calling an external API.

## Parse, don't validate

Boundary code MUST convert raw or untrusted input into typed domain models before passing data to inner application code.

Use protocol objects ONLY when the wire shape differs from the domain model. Never use `DTO` or `Dto` in symbol names. Name symbols after their domain or protocol purpose, such as `CreateUserRequest`, `StripeCustomerResponse`, or `UserRecord`:

```ts
unknown -> CreateUserRequest -> CreateUserInput -> EmailAddress/UserId/etc.
```

If no transformation is needed, parse directly into the input type:

```ts
unknown -> CreateUserInput
```

Do NOT pass schema-inferred types directly into core application code:

```ts
unknown -> z.infer<typeof CreateUserSchema>
```

Use explicit function names:

- `parseX(input): Result<X, ParseXError>` for untrusted or raw input
- `makeX(...)` or `createX(...)` for constructors building from validated pieces
- `isX(value): value is X` for type guard predicates
- `assertX(...)` sparingly, mainly in tests or framework boundaries

Do NOT name a function `validateX` if it returns a parsed type.

### Schemas

Use schema libraries as boundary parsers, not as ad-hoc validators inside business logic.

Preference order:

1. Existing project schema library
2. Effect Schema (in Effect codebases)
3. Standard Schema compatible libraries
4. Zod 4
5. Plain smart constructors for small domain types

Schema parsing MUST return refined domain types and typed custom errors.

Parse input at every boundary where external or stored data enters typed code. This includes database reads, cache hits, RPC responses, queue events, workflow replays, and serialized states. Writing data safely does NOT guarantee stored data remains valid.

## Branded types and correct construction

Use branded types to prevent mixing raw values or constructing invalid state, especially for:

- Identifiers: `UserId`, `OrgId`, `WorkflowId`
- Parsed strings: `EmailAddress`, `NonEmptyString`, `Url`
- Restricted numbers: `PositiveInt`, `Cents`, `Percentage`
- Units: `Milliseconds`, `Bytes`, `UsdCents`

Construct branded values through parsers or smart constructors. Do NOT pass raw strings or numbers where a domain type exists.

Avoid `undefined` or `null` in functions that require a value. Parse or branch before calling the function.

Do NOT use `Partial<T>` as a domain input unless partial updates are an explicit domain capability. Create explicit input types for each operation.

## State machines and boolean blindness

When an entity has multiple lifecycle states, model states using tagged unions.

Prefer tagged unions:

```ts
type Invoice =
  | {
      readonly _tag: "Draft";
      readonly id: InvoiceId;
      readonly lines: NonEmptyArray<LineItem>;
    }
  | { readonly _tag: "Sent"; readonly id: InvoiceId; readonly sentAt: Instant }
  | { readonly _tag: "Paid"; readonly id: InvoiceId; readonly paidAt: Instant };
```

Do NOT use optional boolean flags to track state:

```ts
type Invoice = {
  readonly isSent: boolean;
  readonly isPaid: boolean;
  readonly sentAt?: Date;
  readonly paidAt?: Date;
};
```

Do NOT pass boolean flags to control function behavior:

```ts
createUser(input, true);
```

Prefer named options objects:

```ts
createUser(input, { emailVerification: "skip" });
```

Booleans ARE appropriate for pure predicate functions:

```ts
isExpired(token): boolean;
hasPermission(user, permission): boolean;
```

For complex calls, pass primary domain inputs positionally and group extra options into an options object.

Handle closed tagged unions exhaustively using `casesHandled` or switch checks. Do NOT add default fallback branches that silently ignore missing union tags.

## Modules and abstractions

**Domain Module**, **Application Service Module**, and **Adapter Module** define responsibilities, NOT folder structures or required suffixes. A module MAY be a function, object, class, file, or package. Do NOT create extra layers unless needed.

The standard dependency flow for an application operation is:

```txt
external input -> inbound Adapter -> Application Service -> Domain Module
                                           |
                                           +-> application-owned port
                                                 -> outbound Adapter -> external system
```

An inbound adapter MAY call a domain module directly ONLY IF the operation is pure and needs no authorization, application policy, database access, or external calls:

```txt
external input -> inbound Adapter -> Domain Module
```

The composition root constructs adapters and passes them to application services. Dependencies MUST point inward:

- Domain modules MUST NOT depend on services or adapters.
- Application services MUST depend on application-owned port contracts, not concrete tech.
- Adapters MUST implement port contracts and convert data at system edges.

### Choosing a role

Classify code by what causes it to change:

- Business rules, invariants, calculations, or state transitions: **Domain Module**.
- Application policy, authorization, or effect ordering: **Application Service Module**.
- Frameworks, protocols, databases, or third-party APIs: **Adapter Module**.
- Wiring, resource setup, or configuration: **Composition Root**.

Split code if it has more than one reason to change. Do NOT split code just to fit taxonomy.

### Applying the roles in any codebase

When implementing a feature or refactoring:

1. Trace the operation from entry to all side effects.
2. Put business rules and calculations in Domain Modules.
3. Put application policy and effect ordering in an Application Service with narrow ports.
4. Put technology translations in inbound or outbound Adapters.
5. Wire adapters to ports at the composition root.
6. Verify each layer through its public interface.

Follow existing repository layouts. Wrap legacy code at adapter boundaries instead of triggering broad rewrites.

For example, in password reset: `EmailAddress` and `ResetToken` are Domain Modules; `PasswordReset` is the Application Service; an HTTP route is an inbound Adapter; Postgres and email providers are outbound Adapters; bootstrap performs wiring.

### Deep modules

A deep module hides complex logic behind a simple interface. Callers SHOULD perform operations with minimal setup and without knowing internal details.

Do NOT create shallow wrapper modules that only forward calls or rename APIs.

Use the deletion test:

- If deleting the module removes complexity, it was pass-through waste.
- If deleting the module spreads complexity across callers, it was valuable.

### Cohesion and abstractions

- **Extract helpers only when earned**: Inline simple logic until reuse or complexity justifies a helper. Do NOT split code into tiny helpers just for visual structure.
- **Prefer cohesive files over micro-modules**: Do NOT create a new file for a single small helper used in one place. Keep logic in its owning file. Split files ONLY when introducing a clear boundary or shared module.
- **Avoid code smells**: Do NOT duplicate logic across files. Update existing code instead of adding local workarounds.
- **Preserve raw data & single source of truth**: Do NOT discard raw data early. Keep one data shape per concept. Do NOT duplicate raw, summary, preview, and display fields unless required by contracts.
- **Decouple UI display logic**: Keep display logic inside UI components. Application services produce state; UI components render state.

### Domain modules

A domain module groups one main domain type with its rules and operations. It MUST use pure functions without side effects.

Use a domain module when code has business rules, calculations, or lifecycle states. Use plain primitives or functions if a domain module adds no protection against invalid state.

A domain module SHOULD:

- Co-locate types, parsers, constructors, predicates, transitions, and formatting functions.
- Return refined domain types from parsers so callers cannot construct invalid data.
- Return expected failures as typed Result values.
- Remain pure and deterministic (no I/O, database access, network calls, random values, or global state).

Domain modules MUST NOT perform network calls, query databases, check permissions, or format protocol responses.

Example:

```ts
// email-address.ts

/** A parsed, normalized email address. */
export type EmailAddress = Brand<string, "EmailAddress">;

/** Parse an email address from untrusted input. */
export function parse(input: string): Result<EmailAddress, InvalidEmailAddress>;

/** Render an email address as a string. */
export function toString(email: EmailAddress): string;

/** Compare two email addresses for equality. */
export function equals(left: EmailAddress, right: EmailAddress): boolean;
```

Domain modules MAY use plain functions, immutable value objects, or static classes. If using classes:

- Construct instances using `parse` or smart constructors.
- Make invalid states unconstructable.
- Keep fields readonly and immutable.
- Avoid side effects or hidden dependencies in class methods.
- Do NOT use inheritance for domain behavior.

### Application service modules

An application service module manages one application workflow (such as `PasswordReset` or `Invitations`). It applies application policy and coordinates side effects using narrow ports.

Use an application service when an operation coordinates permissions, storage, network calls, transactions, timers, or logging.

An application service SHOULD:

- Accept and return domain types with precise error unions.
- Define narrow interface ports for its dependencies.
- Receive dependencies, clocks, and random generators via constructors or injection.
- Control side effect execution and order.
- Remain independent of HTTP, CLI, database, or SDK types.

Do NOT parse HTTP requests, render responses, or execute direct SQL inside an application service. Inject dependencies via constructors (or Effect layers).

Split service methods if they serve unrelated tasks or need different dependencies.

### Adapter modules

An adapter module manages technology details and protocol translation at system boundaries.

Two directions exist:

- **Inbound Adapter**: Parses external requests/events, calls an Application Service (or pure Domain Module), and formats responses (e.g., HTTP routes, GraphQL resolvers, CLI commands, queue consumers).
- **Outbound Adapter**: Implements an application port using a concrete technology, converting database rows or SDK types into domain models and typed errors (e.g., Postgres store, Stripe client, email provider).

Adapters MUST handle schema translation, framework details, and error translation. An adapter MAY retry brief network failures if safe and repeatable. Adapters MUST NOT define business rules or application workflow order. Keep raw database or SDK types inside adapters.

A port contract is NOT an adapter. A port defines what a service needs; an adapter provides the implementation. Do NOT create pass-through adapters that merely forward calls.

### Composition root

The composition root parses environment configuration, creates resources, initializes adapters, and injects adapters into application services.

Keep framework setup and dependency wiring in the composition root. Do NOT place business logic or domain rules in the composition root.

## Application-owned ports and adapter reuse

Define port interfaces beside the application service that uses them, using domain types instead of provider types. Depend on the smallest required interface capability.

Example port definition:

```ts
type UsersForPasswordReset = {
  findActiveByEmail(
    email: EmailAddress,
  ): Promise<Result<ActiveUser, UserLookupError>>;
};

export class PasswordReset {
  constructor(private readonly users: UsersForPasswordReset) {}
}
```

A wider adapter can implement this port:

```ts
export class PostgresUsers {
  findActiveByEmail(...) { ... }
  findById(...) { ... }
  updateProfile(...) { ... }
}
```

### Adapter reuse audit

Inspect existing adapters before creating new ones.

Preference order:

1. Reuse an existing adapter as-is through a narrow interface port.
2. Add a method to an existing adapter if it fits the adapter's purpose.
3. Create a new adapter ONLY IF existing adapters do not fit.

Create an Architecture Decision Record (ADR) ONLY IF introducing a new shared architectural boundary or major provider strategy. Explain why existing adapters could not be reused.

### Repositories and persistence

Do NOT create a repository per database table by default.

Use repository adapters when they represent clear persistence capabilities. Repositories MUST return domain types and typed errors, NOT raw database rows or ORM errors.

Keep SQL queries, ORM models, and database rows hidden inside persistence adapters.

## Functional core, imperative shell, and entrypoints

Domain modules form the **functional core**. Application services and adapters form the **imperative shell**.

- **Functional Core**: Contains domain logic, state transitions, calculations, and pure parsers. It MUST NOT perform I/O, throw expected errors, or access global state.
- **Imperative Shell**: Manages side effects and technology details. Services handle application policy; adapters handle I/O and protocol conversions.

Entrypoint adapters (routes, controllers, CLI commands) MUST stay thin. They parse raw inputs into domain types, invoke application services, and format outputs. Do NOT write business rules inside controllers or handlers.

Inbound adapters MUST parse user identity and credentials (such as `Principal` or `Session`). Application services MUST check permissions before performing actions.

## Workflows, transactions, and idempotency

Use simple function calls or database transactions for single operations.

Use durable workflows (or sagas) ONLY IF operations require surviving system crashes, long delays, human approvals, or multi-service coordination. Short retries do NOT require durable workflows.

Adapters manage short network retries. Services decide whether to retry application steps. Durable workflows manage retries across system restarts.

Do NOT keep database transactions open across network calls or long operations.

State changes that MAY be retried MUST use idempotency protection:

- Idempotency keys
- Unique database constraints
- Deduplication records
- State machine guards
- Transactional inbox/outbox tables

## Testing

Write end-to-end tests for workflows that run in standard test environments without flaky third-party services. Add focused unit tests for complex domain rules.

Testing priorities:

1. End-to-end tests through real public interfaces.
2. Integration tests across module boundaries.
3. Property-based tests for pure domain modules.
4. Unit tests for complex logic.

Testing principles:

- Test observable behavior and regressions, NOT implementation details.
- Do NOT test what TypeScript guarantees (types, union shapes, simple getters).
- You MUST NOT add test-only flags, exports, or code to production files.
- Update tests when product behavior changes.

Do NOT use `vi.mock` or `jest.mock` for module mocking. Use real seams:

- Constructor-injected interfaces
- Effect layers
- Local SQLite databases
- In-memory fake adapters

Assert observable outputs in tests:

- Returned values or errors
- Saved database records
- Emitted events
- Sent network requests (recorded in local fakes)

Avoid spy assertions like `expect(sendEmail).toHaveBeenCalledWith(...)` unless the side effect is the only output.

### Property tests and arbitraries

Use `fast-check` for property-based testing of:

- Parsers and constructors
- Branded types
- State machines
- Serialization formats
- Idempotent functions

Export test generator helpers (arbitraries) next to their owning domain module:

```txt
src/billing/
  invoice-number.ts
  invoice-number.test.ts
  invoice-number.arbitrary.ts
```

Tests MUST NOT bypass parsers or domain invariants.

Add compile-time type tests for generic inference functions to prevent type regressions.

## TypeScript style and safety

Enable strict TypeScript options:

- `strict: true`
- `noUncheckedIndexedAccess: true`
- `exactOptionalPropertyTypes: true`
- `noImplicitOverride: true`
- `noFallthroughCasesInSwitch: true`

Prefer immutable types:

```ts
type CreateUserInput = {
  readonly email: EmailAddress;
  readonly roles: ReadonlyArray<Role>;
};
```

Local mutation IS acceptable inside internal loops, builders, or performance-critical code when hidden from callers.

Do NOT write explicit types when TypeScript infers them automatically for local variables and simple helpers.

Provide explicit return types for exported functions and public API contracts.

Avoid deeply nested code. Use guard clauses and early returns.

### Casts, any, and non-null assertions

Avoid using:

- `any`
- Non-null assertions (`!`)
- Type assertions (`as Type`)

`as const` IS allowed.

If a type assertion (`as Type`) is required, you MUST include a safety comment:

```ts
// SAFETY: TypeScript cannot infer the brand. parseEmailAddress validated the normalized string.
return normalized as EmailAddress;
```

If `any` is required, you MUST include an linter ignore and explanation:

```ts
// oxlint-disable-next-line no-explicit-any -- SAFETY: Helper handles arbitrary parameters; TypeScript cannot express this variadic constraint without any.
type Fn = (...args: any[]) => unknown;
```

Do NOT use the non-null assertion operator (`!`). Use explicit guards or type checks instead.

## Imports, exports, and files

Import symbols directly from their defining file. Avoid barrel files (`index.ts`). Use `main.ts` for package entrypoints. Do NOT use `index.ts`.

Use namespace imports for domain modules:

```ts
import * as EmailAddress from "./email-address";

EmailAddress.parse(input);
```

Use named imports for classes and standalone helpers:

```ts
import { PasswordReset } from "./password-reset";
```

Use `import type` and `export type` for type-only symbols.

Use static imports by default. Use dynamic `import()` ONLY for lazy loading or code splitting.

Export ONLY public APIs. Keep internal helpers unexported. Do NOT export internal helpers just for tests.

Do NOT use TypeScript `namespace`.

Do NOT create generic utility files like:

```txt
utils.ts
helpers.ts
common.ts
misc.ts
```

Use descriptive file names:

```txt
email-address.ts
billing-period.ts
string-case.ts
array.ts
```

Shared utility files MAY contain ubiquitous helpers like:

- `casesHandled`
- `shouldNeverHappen`
- `notYetImplemented`
- `Redacted`
- `Result` type helpers

Do NOT set arbitrary file length limits. Split files ONLY when a file has multiple unrelated reasons to change.

## Comments and JSDoc

Comments MUST explain invariants, trade-offs, and non-obvious business rules. Do NOT write comments that explain obvious code.

Public APIs, exported symbols, and exported class members MUST include JSDoc comments. Private internal code requires JSDoc ONLY IF logic is complex.

Do NOT use `@inheritDoc` or `@inherit`. Write explicit JSDoc comments on declarations.

Use standard JSDoc format:

```ts
/**
 * Parse an email address from untrusted input.
 *
 * @param input - The untrusted string to parse.
 * @returns A parsed email address, or `InvalidEmailAddress` when the input is invalid.
 */
export function parse(input: string): Result<EmailAddress, InvalidEmailAddress>;
```

For generic parameters:

```ts
/**
 * Map the success value of a result.
 *
 * @template T - The original success type.
 * @template U - The mapped success type.
 * @template E - The error type.
 * @param result - The result to map.
 * @param fn - The function applied to the success value.
 * @returns A result with the mapped success value, or the original error.
 */
export function map<T, U, E>(
  result: Result<T, E>,
  fn: (value: T) => U,
): Result<U, E>;
```

Use `@throws` ONLY for unrecoverable defects or unimplemented code paths. Do NOT document expected typed errors as throws.

Document complex object properties:

```ts
/** Input required to create a user. */
export type CreateUserInput = {
  /** The actor creating the user. */
  readonly actor: AdminUser;

  /** The parsed email address for the new user. */
  readonly email: EmailAddress;
};
```

## Configuration and resources

Parse environment variables at application startup into typed, branded, or redacted configuration objects. Return startup errors as tagged Result errors and exit safely.

Do NOT access `process.env` throughout application code.

Do NOT execute top-level side effects during file import. Modules MUST NOT open network connections or database handles on import.

Resource setup and teardown MUST be explicit and managed by application startup code or Effect layers.

Do NOT use mutable singletons or global state. Inject dependency services (like clocks or random generators) explicitly.

## Quick agent checklist

Before writing code:

- Read existing project conventions for errors, schemas, tests, adapters, and module layouts.
- Classify changes into Domain Module, Application Service Module, Adapter Module, or Composition Root.
- Reuse existing domain modules, application services, and adapters before creating new ones.
- Define side-effect dependencies as narrow application-owned interface ports.
- Parse inputs at system edges into domain types.
- Do NOT use raw DTOs, raw IDs, or `Partial<T>` in application logic.
- Return typed error values for expected failures.
- Preserve existing logging and observability hooks.
- Test through public interfaces and real seams.
- Use `fast-check` arbitraries for generated test data.
- Add JSDoc to exported symbols.
- Create an ADR ONLY IF adding a new shared architectural boundary or major provider strategy.
