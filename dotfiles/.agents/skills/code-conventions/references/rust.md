# Rust Reference

Source: [Google Rust Style Guide](https://google.github.io/styleguide/rustguide.html), application-code subset. Where this file and SKILL.md disagree, SKILL.md wins.

## Types

- Match a closed enum exhaustively, with no wildcard arm, and do not mark it `#[non_exhaustive]`. This overrides the Google guide.

## Imports

- No glob imports. `use super::*` in a test module is the one exception.

## Unsafe and Comments

- Every `unsafe` block carries a `// SAFETY:` comment stating why it is sound and why safe code cannot express the invariant. Prove the invariant with a test/Miri/Valgrind before shipping the block.
- Aside from `// SAFETY:`, the only allowed comments are spec/RFC URL citations (`// https://...` or `/// <https://...>`) and an optional 1-line spec disagreement or UA-defined constant note attached to the URL.
