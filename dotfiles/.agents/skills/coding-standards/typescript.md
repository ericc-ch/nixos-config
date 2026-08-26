# TypeScript Annex

Read this alongside SKILL.md whenever you write TypeScript.

## Compiler

Enable these options and treat violations as errors:

```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "exactOptionalPropertyTypes": true,
  "noImplicitOverride": true,
  "noFallthroughCasesInSwitch": true
}
```

## Types

- Mark inputs `readonly` and use `ReadonlyArray<T>` instead of `T[]`.
- Brand raw primitives so values cannot mix: `type EmailAddress = Brand<string, "EmailAddress">`.
- `as const` is always allowed.
- Avoid `any`, non-null assertions (`!`), and type assertions (`as Type`). When a cast is unavoidable, add a SAFETY comment:

```ts
// SAFETY: parseEmailAddress validated the normalized string. TypeScript cannot infer the brand.
return normalized as EmailAddress;
```

- When `any` is unavoidable, disable the lint rule with an explanation:

```ts
// oxlint-disable-next-line no-explicit-any -- SAFETY: TypeScript cannot express this variadic constraint without any.
type Fn = (...args: any[]) => unknown;
```

- Write explicit return types on exported functions. Let local variables infer their types.

## Errors

Error channel preference:

1. Effect, if the project already uses it.
2. `better-result`, if available and appropriate.
3. A local tagged union:

```ts
type Result<T, E extends Error> =
  | { readonly _tag: "ok"; readonly value: T }
  | { readonly _tag: "err"; readonly error: E };
```

Expected failures resolve to `Result` values, never to rejections. A rejected promise equals a thrown exception:

```ts
// Wrong: rejects for ordinary lookup or storage failures.
function findUser(id: UserId): Promise<User>;

// Right: resolves with the failure as a value.
function findUser(id: UserId): Promise<Result<User, UserLookupError>>;
```

Expected failures use custom tagged errors extending `Error`. Each carries a stable `_tag`, a message built by the owning module, structured context, and an optional cause:

```ts
export class UserStoreUnavailable extends Error {
  readonly _tag = "UserStoreUnavailable" as const;

  constructor(
    readonly operation: string,
    readonly provider: string,
    readonly cause: unknown,
  ) {
    super(`User store unavailable during ${operation}`);
  }
}
```

Shared defect helpers live in one place. Reuse them instead of creating variants:

```ts
export function casesHandled(unexpectedCase: never): never;
export function shouldNeverHappen(msg?: string): never;
export function notYetImplemented(msg?: string): never;
```

Use `casesHandled` for exhaustive switch checks.

## Schemas

Boundary parser preference order:

1. The project's existing schema library.
2. Effect Schema, in Effect codebases.
3. Standard Schema compatible libraries.
4. Zod 4.
5. Plain smart constructors for small domain types.

Parsing returns refined domain types and typed custom errors. Do not pass schema-inferred types into core code. Map them into named input types first:

```txt
// Wrong:
unknown -> z.infer<typeof CreateUserSchema> -> core

// Right:
unknown -> CreateUserRequest -> CreateUserInput -> EmailAddress, UserId, ...
```

## Imports and files

- Import domain modules under their namespace so call sites read `EmailAddress.parse(input)`:

```ts
import * as EmailAddress from "./email-address";
```

- Import classes and standalone helpers by name: `import { PasswordReset } from "./password-reset"`.
- Use `import type` and `export type` for type-only symbols. Never use the `namespace` keyword.
- Package entrypoints use `main.ts`. Do not create barrel `index.ts` files.

## Doc comments

Write JSDoc on every exported symbol:

```ts
/**
 * Parse an email address from untrusted input.
 *
 * @param input - The untrusted string to parse.
 * @returns A parsed email address, or `InvalidEmailAddress` when input is invalid.
 */
export function parse(input: string): Result<EmailAddress, InvalidEmailAddress>;
```

Document generic parameters with `@template`. Use `@throws` only for unrecoverable defects and unimplemented paths. Expected typed errors appear in the return type, never in `@throws`.

## Effect

- Write business logic with `Effect.gen` and `yield*`. Reserve `.pipe` for composition, transforms, error handling, tracing, and layer building.
- Declare effectful functions with `Effect.fn`. Pass handlers such as `Effect.catch` and `Effect.ensuring` as extra arguments. Never pipe directly onto `Effect.fn`.
- Write sequential steps inside `Effect.gen`. Do not chain `.map`, `.flatMap`, or `.andThen` for sequencing.
- Wrap secrets with `Redacted`. Unwrap only inside adapters, right before the external call.
- Inject dependencies through Layers at the composition root.

## Testing

- Use `fast-check` for property-based testing of parsers, branded types, state machines, serializers, and idempotent functions.
- Co-locate arbitraries beside the module they test:

```txt
src/billing/
  invoice-number.ts
  invoice-number.test.ts
  invoice-number.arbitrary.ts
```

- Never use `vi.mock` or `jest.mock` for module mocking. Inject fakes through constructors or Effect Layers instead.
