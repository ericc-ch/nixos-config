# Rust Reference

Source: [Google Rust Style Guide](https://google.github.io/styleguide/rustguide.html), application-code subset. Where this file and SKILL.md disagree, SKILL.md wins.

## Setup

- rustfmt, with `imports_granularity = "Module"`. Do not `#[rustfmt::skip]` for personal style.
- Deny warnings. Deny the Clippy lints named below rather than a blanket lint group.
- Stable Rust; `#![feature]` only when the crate cannot build without it.

## Types

- An enum over a `bool` parameter that is not a pure predicate. Clippy: `fn_params_excessive_bools`.
- A newtype over a type alias when values are easy to mix up, the type has its own invariants or API, or the inner representation may change.
- Named fields; a tuple struct only for a one-field newtype.
- Match a closed enum exhaustively, with no wildcard arm, and do not mark it `#[non_exhaustive]`. This overrides the Google guide.

## Errors

- `Option` for an expected absence with an obvious cause, `Result` when the caller must tell causes apart, `panic!` only for a violated invariant.
- Match `Option`/`Result` (`if let`, `let`/`else`, `match`). Never check-then-unwrap. Clippy: `unnecessary_unwrap`.
- Panic only through `expect`, naming the invariant. Clippy: `unwrap_used`.
- Never `panic::catch_unwind`.

## Ownership

- Borrow the flexible reference: `&str` not `&String`, `&[T]` not `&Vec<T>`, `&T` not `&Box<T>`, `Option<&T>` not `&Option<T>`. Clippy: `ptr_arg`, `borrowed_box`.
- Take `&[T]`, return `Vec<T>`; `impl Into*` only when call-site ergonomics are the whole point.
- `clone` for a real copy, never to dodge a lifetime.
- Unique ownership by default. `Rc`/`Arc` only for a genuinely shared graph such as DOM/JS; cloning one copies the pointer.
- Leave a poisoned mutex poisoned.

## Imports

- One module per `use`: `use foo::bar::{Bar, Baz}`, not `use foo::{Foo, bar::Bar}`.
- No glob imports. `use super::*` in a test module is the one exception.
- Types unqualified (`Regex`); qualify or rename short ambiguous names (`io::Error`).
- Import a trait inside the function that uses it, unless most of the file does.

## Traits

- Define a trait only to bound a generic, accept or return `impl`/`dyn Trait`, or extend a foreign type (`FooExt`). Otherwise use an inherent impl.
- Implement the std trait over a same-contract method (`FromStr`, `From`, `Default`). Clippy: `should_implement_trait`.
- `#[derive]` when the impl is what derive would generate. Clippy: `derivable_impls`.
- `new()` implies `Default`; a fallible constructor is `try_new()`; pair a primary `From` with `from_foo()`. Clippy: `new_without_default`.
- Public options struct → `Default`. `len()` comes with `is_empty()`. Clippy: `len_without_is_empty`.

## Unsafe

- Safe code first. `unsafe` only for FFI or an invariant the type system cannot express, hidden behind a safe function and kept out of business logic.
- Every `unsafe` block carries a `// SAFETY:` comment stating why it is sound and why safe code cannot express the invariant. This is the one internal comment SKILL.md allows. Clippy: `undocumented_unsafe_blocks`.
- Prove the invariant with a test or Miri before shipping the block.
- Document an `unsafe fn`'s caller obligations.

## Control flow

- `for` when a chain is long, branches, or mutates outer state; a short `any`/`filter`/`map` when the combinator is the whole operation.
- Bind a chain to a named variable before looping; no chain in the `for` header.
- No `Iterator::for_each`.

## Naming

- `foo` / `foo_mut` / `set_foo` / `take_foo` / `replace_foo`, plus `with_foo` / `with_mut_foo` for closure accessors.
- `as_` / `to_` / `into_` with the matching `self` receiver. Clippy: `wrong_self_convention`.
- `#[must_use]` when the caller must use the result (pure function, lazy handle, error type); redundant when the type is already `#[must_use]`, as `Result` is. Clippy: `must_use_candidate`.

## Macros and startup

- Function or type first, `macro_rules!` second, proc macro last. No preludes.
- No code before `main`: no `ctor`, no inventory registration, no module-load work.
