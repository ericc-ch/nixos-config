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

## Packaging

- Package entrypoint is `main.ts`. Never create barrel `index.ts` files.
