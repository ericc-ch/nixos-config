# TypeScript Reference

## Setup

- Every TypeScript project uses Effect.
- `/tmp/references/effect` holds the Effect repository (v4, `main` branch): `https://github.com/Effect-TS/effect.git`. Read it.
- `tsconfig.json` enables `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, and `noFallthroughCasesInSwitch`.
- Parse only with `Schema` from `effect`.
- Install `@effect/language-service` as a dev dependency, register it in `tsconfig.json` (`"plugins": [{ "name": "@effect/language-service", "namespaceImportPackages": ["effect", "@effect/*"] }]`), and set `"prepare": "effect-language-service patch"` so Effect diagnostics fail `tsc`.

## Types

- Check a value against a contract with `satisfies`. Never widen it with an annotation.
- `unknown` appears only at the parse boundary and on `cause` fields. Never write `unknown` parameters, `unknown` returns, or type aliases that resolve to `unknown`. Never branch on `typeof` for external values; decode them with `Schema`.
- Never omit an optional property with a conditional empty spread (`...(x ? { k: x } : {})`). Branch on the whole object: `x === undefined ? base : { ...base, k: x }`.
- Hot files (`*.hot.ts`) never contain object or array literals, closures, `new`, spreads, template literals with expressions, or calls that return new arrays (`map`, `filter`, `slice`, `concat`, `flatMap`). A lint rule scoped to `**/*.hot.ts` rejects these AST nodes: `ObjectExpression`, `ArrayExpression`, `ArrowFunctionExpression`, `FunctionExpression`, `NewExpression`, `SpreadElement`, `TemplateLiteral` with expressions, and those method calls.

## Errors and tags

- Define domain errors with `Data.TaggedError("NotFound")<{ ...fields }>` or `Schema.TaggedError<NotFound>()("NotFound", { ...fields })`. The tag is the first constructor argument. The runtime sets `_tag` from it. Never write `_tag` by hand.
- Never read or compare `_tag` directly. Use the helper for the job:
  - Handle errors by tag: `Effect.catchTag` / `Effect.catchTags`.
  - Type-guard a tagged value: `Predicate.isTagged(value, "Tag")`.
  - Discriminate a `Data.TaggedEnum` union: its `$is` and `$match`.
  - Match exhaustively on any tagged union: `Match.type` + `Match.tag` + `Match.exhaustive`.
  - Branch on literal values with `Match.value(x).pipe(Match.when(...), Match.exhaustive)`. Never chain ternaries.
  - The one exception: comparing `_tag` in a test assertion.
- Never use `Effect.orDie`, except where the expected failure already travels as a typed outcome.

## Writing effects

- Write sequential logic with `Effect.gen` and `yield*`. Never chain `.flatMap` or `.andThen`.
- Never declare an effectful function as an arrow that builds an Effect (`const f = (x: X) => Effect.gen(...)`). Declare it with `Effect.fn` instead:
  - `Effect.fn("f")(function*(x: X) { ... })`. The name matches the function name and becomes its tracing span.
  - Use `Effect.fnUntraced` when tracing is not needed.
  - Pass handlers like `Effect.catch` as trailing arguments. Never `.pipe` onto `Effect.fn`.
- Use `.pipe` only for composition, transforms, and layer building.
- Pure domain rules are ordinary functions, never Effects.
- HTTP adapters use `HttpClient.filterStatusOk` and `HttpClientResponse.schemaBodyJson(Schema)`.

## Context services

- A `Context.Service` with one implementation is allowed only when its `make` captures dependencies. Otherwise write a plain function.
- Define services with `Context.Service`. Never use `Context.Tag`, `Effect.Tag`, or `Effect.Service`.
- The string id is the runtime identity. Never reuse the same id for unrelated services.
- Read a service with `yield*` in `Effect.gen`. Never use `Service.use` or `Service.useSync`.
- Name the primary layer `layer`. Name variants with a suffix (`layerTest`, `layerConfig`). Wire other services with `Layer.provide`. There is no `dependencies` option.
- When this module owns construction, the service is a class with `make`. Infer the shape from `make`. Never pass a `Shape` type argument:
  - `class Logger extends Context.Service<Logger>()("Logger", { make: Effect.gen(function*() { ... }) }) { static readonly layer = Layer.effect(this)(this.make) }`
  - `make` stores the constructor. It does not create a layer. Add `static readonly layer` yourself.
  - If `make` needs arguments, use `Effect.fn` or `Effect.fnUntraced`. Never an arrow that returns an Effect.
  - If construction acquires a resource, use `Effect.acquireRelease` inside `make` and build the resource inside the acquire Effect. `Layer.effect` runs that Effect in the layer scope.
- Runtime code never imports a service's `make`. Import its `Layer` and `yield*` the service.
- When the class is only a key (another module supplies the implementation, or the value is request-scoped like `CurrentUser`), it has no `make`:
  - `class Database extends Context.Service<Database, { readonly query: (sql: string) => Effect.Effect<string> }>()("Database") {}`
  - Build the layer next to the implementation. `Layer.succeed` for a ready value, `Layer.effect` for an Effect constructor. Use `Service.of` to type-check an implementation object.
- Use `const Database = Context.Service<Shape>("Database")` only for a local, unexported key. Exported services are classes.
- Use `Context.Reference` only when a default must exist even if nothing provides the service: `Context.Reference<"info" | "warn" | "error">("LogLevel", { defaultValue: () => "info" })`.
- Never mock modules (`vi.mock`, `jest.mock`). Provide a test `Layer` for a service the code already declares.

## Packaging

- The package entrypoint is `main.ts`. Never create barrel `index.ts` files.
