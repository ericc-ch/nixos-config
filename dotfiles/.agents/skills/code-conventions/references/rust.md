# Rust Reference

- Never write a `_` wildcard arm in a `match` over an enum this crate defines. Never mark an enum `#[non_exhaustive]`.
- The only allowed glob import is `use super::*` in a `#[cfg(test)]` module.
- Never use `as` for a numeric conversion that can truncate or change sign. Use `From` or `TryFrom`.
- Every `unsafe` block carries a `// SAFETY:` comment stating why it is sound and why safe code cannot express the invariant. Prove the invariant with a test, Miri, or Valgrind before shipping the block.
- Hot files (`*_hot.rs`) never allocate: no `Vec::`, `vec!`, `Box::`, `String::`, `Rc::`, `Arc::`, `HashMap::`, `format!`, `.to_string()`, `.to_owned()`, `.to_vec()`, `.collect()`, or `.clone()`. Hot functions write into caller-owned buffers.
- `scripts/check-hot.sh` enforces it in pre-commit and CI. It fails on any match of `rg -n -e 'Vec::|vec!|Box::|String::|Rc::|Arc::|HashMap::|format!|\.to_string\(|\.to_owned\(|\.to_vec\(|\.collect|\.clone\(' --glob '*_hot.rs'`.
