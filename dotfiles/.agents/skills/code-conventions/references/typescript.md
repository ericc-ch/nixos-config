# TypeScript Reference

Read this alongside SKILL.md when writing TypeScript.

## Mandatory Effect Rule

- Effect is mandatory for all TypeScript projects.
- Model all side effects and fallible operations using `Effect`.
- Never throw exceptions or reject promises for expected business failures.
- Never use raw `Promise` or async/await in application or domain code.
- Run effects only at the process boundary (composition root or entrypoint) with `Effect.runPromise` or `NodeRuntime.runMain`.

## Compiler

Enable these options in `tsconfig.json` and treat violations as errors:

```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "exactOptionalPropertyTypes": true,
  "noImplicitOverride": true,
  "noFallthroughCasesInSwitch": true
}
```

## Types and Schemas

- Use `@effect/schema` (`Schema`) for all data modeling, parsing, and boundary validation.
- Model domain entities with `Schema.Struct` and `Schema.TaggedStruct`.
- Brand primitives with `Schema.brand` so values cannot mix:

```ts
import { Schema } from "effect";

export const UserId = Schema.String.pipe(Schema.brand("UserId"));
export type UserId = Schema.Schema.Type<typeof UserId>;
```

- Mark input arguments `readonly`. Use `ReadonlyArray<T>` instead of mutable arrays.
- Avoid `any`, `unknown` casts, type assertions (`as Type`), and non-null assertions (`!`).
- Write explicit return types on exported functions. Let local variables infer their types.
- `as const` is always allowed.

## Errors

- Define domain errors with `Data.TaggedError` or `Schema.TaggedError`.
- Every error class must have a unique `_tag` property and structured context fields:

```ts
import { Data } from "effect";

export class UserNotFoundError extends Data.TaggedError("UserNotFoundError")<{
  readonly userId: string;
}> {}

export class DatabaseUnavailableError extends Data.TaggedError("DatabaseUnavailableError")<{
  readonly operation: string;
  readonly cause: unknown;
}> {}
```

- Handle errors explicitly using `Effect.catchTag`, `Effect.catchTags`, or `Effect.catchAll`.
- Use `Match` from `effect` for exhaustive pattern matching on tagged unions.

## Effect Workflow

- Write multi-step business logic using `Effect.gen` and `yield*`.
- Do not chain `.map`, `.flatMap`, or `.andThen` to sequence operations.
- Declare effectful functions with `Effect.fn`:

```ts
import { Effect } from "effect";

export const getUser = Effect.fn("getUser")(function* (id: UserId) {
  const user = yield* findUser(id);
  return user;
});
```

- Pass error and resource handlers as trailing arguments in `Effect.fn`. Do not pipe directly onto `Effect.fn`.
- Reserve `.pipe` for composition, transforms, and building layers.

## Services and Dependencies

- Define service interfaces with `Context.Tag`.
- Implement services with `Layer`.
- Define only the methods that the calling service needs.
- Inject dependencies at the application entrypoint using `Layer.provide`.

```ts
import { Context, Effect, Layer } from "effect";

export class UserRepo extends Context.Tag("UserRepo")<
  UserRepo,
  { readonly findById: (id: UserId) => Effect.Effect<User, UserNotFoundError> }
>() {}

export const UserRepoLive = Layer.succeed(
  UserRepo,
  UserRepo.of({
    findById: (id) => Effect.succeed({ id, name: "Alice" }),
  })
);
```

## Imports and Structure

- Import domain modules as namespaces:

```ts
import * as EmailAddress from "./email-address";
```

- Import classes, errors, and tags by name:

```ts
import { UserRepo, UserNotFoundError } from "./user";
```

- Use `import type` and `export type` for type-only symbols.
- Never use TypeScript `namespace` or `enum` keywords.
- Name the application entrypoint `main.ts`.
- Do not create barrel `index.ts` files.
