# TypeScript Reference

## Setup

- Effect is mandatory for all TypeScript projects.
- Include the Effect repository (v4 on main) in the reference script's `REPOSITORIES` list. You have to read it.
- Enable strict compiler flags in `tsconfig.json`: `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, and `noFallthroughCasesInSwitch`. Treat violations as errors.
- Use `Schema` from `effect`.
- Set up the Effect language service:
  - Install `@effect/language-service` as a dev dependency.
  - Register it in `tsconfig.json`: `"plugins": [{ "name": "@effect/language-service", "namespaceImportPackages": ["effect", "@effect/*"] }]`.
  - Point your editor at the workspace TypeScript version so tsserver loads the plugin (VS Code: TypeScript: Select TypeScript Version → Use Workspace Version; Neovim: vtsls or another tsserver-plugin-aware LSP).
  - Read the [language-service README](https://github.com/Effect-TS/language-service) for editor-specific setup details.

## Errors and tags

- Define domain errors with `Data.TaggedError("NotFound")<{ ...fields }>` or `Schema.TaggedError<NotFound>()("NotFound", { ...fields })`. The tag is the first constructor argument; `_tag` is set from it automatically, never written by hand.
- Never read or compare `_tag` directly. Use the helper for the job:
  - Handle errors by tag: `Effect.catchTag` / `Effect.catchTags`.
  - Type-guard a tagged value: `Predicate.isTagged(value, "Tag")`.
  - Discriminate a `Data.TaggedEnum` union: its `$is` and `$match`.
  - Match exhaustively on any tagged union: `Match.type` + `Match.tag` + `Match.exhaustive`.
  - The one exception: comparing `_tag` in a test assertion.

## Writing effects

- Write sequential logic with `Effect.gen` and `yield*`. Do not chain `.flatMap` or `.andThen`.
- Never declare an effectful function as an arrow that builds an Effect (`const f = (x: X) => Effect.gen(...)`). Declare it with `Effect.fn` instead:
  - `Effect.fn("f")(function*(x: X) { ... })` — the name matches the function name and becomes its tracing span.
  - Use `Effect.fnUntraced` when tracing is not needed.
  - Pass handlers like `Effect.catch` as trailing arguments. Never `.pipe` onto `Effect.fn`.
- Reserve `.pipe` for composition, transforms, and layer building.

## Context services

- Define services with `Context.Service`. Do not use `Context.Tag`, `Effect.Tag`, or `Effect.Service`.
- The string id is the runtime identity. Never reuse the same id for unrelated services.
- Read a service with `yield*` in `Effect.gen`. Do not default to `Service.use` or `Service.useSync`.
- Name the primary layer `layer`. Name variants with a suffix (`layerTest`, `layerConfig`). Wire other services with `Layer.provide`. There is no `dependencies` option.
- Prefer a class with `make` when this module owns construction. Infer the shape from `make`. Do not pass a `Shape` type argument:
  - `class Logger extends Context.Service<Logger>()("Logger", { make: Effect.gen(function*() { ... }) }) { static readonly layer = Layer.effect(this)(this.make) }`
  - `make` stores the constructor. It does not create a layer. Add `static readonly layer` yourself.
  - If `make` needs arguments, use `Effect.fn` or `Effect.fnUntraced`. Never an arrow that returns an Effect.
  - If construction acquires a resource, use `Effect.acquireRelease` inside `make`. `Layer.effect` runs that Effect in the layer scope.
- Use a class without `make` when the class is only a key: another module supplies the implementation, or the value is request-scoped (`CurrentUser`):
  - `class Database extends Context.Service<Database, { readonly query: (sql: string) => Effect.Effect<string> }>()("Database") {}`
  - Build the layer next to the implementation. `Layer.succeed` for a ready value, `Layer.effect` for an Effect constructor. Use `Service.of` to type-check an implementation object.
- Use `const Database = Context.Service<Shape>("Database")` only for a local, unexported key. Exported services are classes.
- Use `Context.Reference` only when a default must exist even if nothing provides the service: `Context.Reference<"info" | "warn" | "error">("LogLevel", { defaultValue: () => "info" })`.

## Packaging

- Package entrypoint is `main.ts`. Never create barrel `index.ts` files.
