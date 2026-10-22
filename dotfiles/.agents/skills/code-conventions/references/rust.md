# Rust Reference

Source: [Google Rust Style Guide](https://google.github.io/styleguide/rustguide.html). Application-code subset; where this file and SKILL.md disagree, SKILL.md wins.

## Setup

- Format with rustfmt. Set `imports_granularity = "Module"`.
- Deny warnings. Deny every Clippy lint named below. Do not enable a whole Clippy group.
- Stay on stable Rust. Add `#![feature]` only when the crate cannot build without it.

## Types

- Prefer an enum over a `bool` parameter whose meaning is not a pure predicate. Group several flags into one named struct or enum. Clippy: `fn_params_excessive_bools` (fires on several `bool` parameters; one unclear flag is still an enum).
- Use a newtype when two values are easy to mix up, when the type has its own invariants or API, or when the inner representation may change. A type alias is transparent and does none of these.
- Prefer named fields. Use a tuple struct only for a one-field newtype. Use a tuple only for a value that never leaves the function that built it.
- Match every variant of a closed enum. Leave the enum exhaustive. Do not mark it `#[non_exhaustive]`.
- Prefer type inference. Write a type only when the compiler cannot infer it.

## Errors

- Return `Option` when failure is an expected absence and the cause is obvious (missing key, parse mismatch).
- Return `Result` when the caller must tell recoverable causes apart (I/O, an FFI status).
- `panic!` only for a violated invariant: a precondition the type system cannot express. State that invariant in the message. Tests may panic on a failed assertion.
- Match on `Option` and `Result` (`if let`, `let`/`else`, `match`). Do not check and then unwrap (`is_some` then `unwrap`, `is_ok` then `unwrap`). Clippy: `unnecessary_unwrap`.
- When a panic is the right signal, call `expect` and name the invariant. Do not call `unwrap`. Clippy: `unwrap_used`. Leave `expect_used` off.
- Do not call `panic::catch_unwind`.

## Ownership

- Accept the flexible borrow: `&str` not `&String`, `&[T]` not `&Vec<T>`, `&T` not `&Box<T>`, `Option<&T>` not `&Option<T>`. Clippy: `ptr_arg` (`&String`, `&Vec`), `borrowed_box` (`&Box`).
- In application code, take `&[T]` to iterate. Take `impl IntoIterator` only when callers pass non-slice sources. Return `Vec<T>` when the caller needs an owned collection. Do not take `impl Into<T>` to skip a call-site `.into()`.
- Borrow. Call `clone` for a real copy. Do not clone to dodge a lifetime.
- Unique ownership is the default. Use `Rc` or `Arc` only for a graph that is genuinely shared. A DOM or JS object graph is that case. Cloning an `Rc` or `Arc` copies the pointer, not the value.
- Leave a poisoned mutex poisoned. Do not call `into_inner` to keep going.

## Imports

- One module per `use`. `use foo::bar::{Bar, Baz}` is fine. `use foo::{Foo, bar::Bar}` is not.
- Do not glob-import. The one exception is `use super::*` in a test module; allow `wildcard_imports` on that import. Clippy: `wildcard_imports`, `enum_glob_use`.
- Import a type and use the bare name (`Regex`, not `regex::Regex`). Qualify a short ambiguous name (`io::Error`) or rename it.
- Import a trait inside the function that uses it, unless most of the file calls its methods.

## Traits

- Do not define a trait to group methods. Write an inherent impl. Define a trait to bound a generic, to accept or return `impl Trait` or `dyn Trait`, or to extend a foreign type (`FooExt`).
- Implement the standard trait instead of a custom method with the same contract: `FromStr` not `from_str`, `From` not a one-off converter, `Default` for a real default. An inherent method may forward to the trait. Clippy: `should_implement_trait`.
- `#[derive]` when the impl is what derive would generate. Clippy: `derivable_impls`.
- `new()` means the type has a default, so implement `Default`. A fallible constructor is `try_new()`. Clippy: `new_without_default`.
- Pair a primary `From` impl with `from_foo()` or `new()`.
- A public options struct (all fields public, passed as a bag of settings) implements `Default`.
- `len()` comes with `is_empty()`. Clippy: `len_without_is_empty`.

## Unsafe

- Write safe code. Use `unsafe` for FFI and for invariants the type system cannot express.
- Hide each `unsafe` block behind a safe function. Keep it out of business logic.
- Every `unsafe` block has a `// SAFETY:` comment on the lines directly above it. This is the one internal comment allowed, and it is an exception to the no-internal-comments rule in SKILL.md. The comment states the invariant that makes the block sound, and why safe code cannot express that invariant. Clippy: `undocumented_unsafe_blocks`.
- State an `unsafe fn`'s caller obligations in its public docs. Clippy: `missing_safety_doc`.

## Control flow

- Use a `for` loop when a combinator chain is long, branches, or mutates outer state. Keep a short chain (`any`, `filter`, `map`) when the combinator is the whole operation.
- Do not build a combinator chain in a `for` header. Bind it, name what it selects, then loop.
- Do not call `Iterator::for_each`. Use `for`.

## Naming

- Getter by value or shared reference: `foo`. Mutable getter: `foo_mut`. Setter: `set_foo`. Take and clear: `take_foo`. Swap in a new value and return the old one: `replace_foo`.
- Closure accessor: `with_foo` / `with_mut_foo`, called as `object.with_foo(|foo| ...)`. Use it when the field sits behind interior mutability so the guard does not escape, or when a change needs a follow-up check that `set_foo` cannot express.
- Name conversions `as_`, `to_`, and `into_` with the matching `self` receiver. Clippy: `wrong_self_convention`.
- Put `#[must_use]` on a function whose return value the caller must use (a pure function, a lazy handle). Skip it when the return type is already `#[must_use]`, as `Result` is. Put `#[must_use]` on an error type or a lazy computation that does nothing until it is used. Clippy: `must_use_candidate`.

## Macros and startup

- Prefer a function or a type. Use `macro_rules!` only when those cannot express the API. Do not start with a proc macro. Do not define a prelude.
- Do not run code before `main`. No `ctor`, no inventory registration, no work at module load.
