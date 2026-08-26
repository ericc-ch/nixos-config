# Walkthrough state: tinybrowser `crates/net/`

Last updated: 2026-08-26, session ses_fc2d5147affebAhocwM1xsTUWL

## Established Rust ↔ TS/Effect mapping

| Rust | TS/Effect model |
|---|---|
| `Result<A, E>` + `?` | `Effect<A, E, R>` minus R (sync, no runtime); `?` = yield* fail-short-circuit |
| `enum` with payloads | closed discriminated union; exhaustive `match` compile-checked |
| `match` + guards (`"PATCH" if …`) | `catchTag`-style pattern match; guard = extra boolean condition on an arm |
| `panic!` | die/defect — bugs only, separate universe from `Err` |
| `Box<str>` / `String` / `&str` | owned fixed buffer (ptr+len) / owned growable (ptr+cap+len) / borrowed view |
| `Box<dyn Trait>` | value typed by its interface (trait object) |
| `&self` / `&mut self` / `self` | readonly method / mutable borrow / consumes the value (single-use) |
| newtype `struct Method(Token)` | branded type, compiler-enforced |
| `impl Into<Vec<u8>>` param | one signature, multiple call shapes (no overloading) |
| `impl Iterator` return | lazy zero-alloc view, like a generator |
| lifetimes (`<'s>`) | compiler-checked "view doesn't outlive its owner" |
| `Arc<Mutex<T>>` | shared mutable state; the lock is in the type, must `.lock()` to touch data |
| Drop / RAII | deterministic finally; "cancellation is dropping" |
| `#[must_use]`, `pub(crate)`/`pub(super)` | lint-enforced don't-ignore; module-level visibility |
| `Display` + `std::error::Error` + `source()` | `.message` + `.cause` chain, typed |
| `From<ureq::Error>` | checked error conversion at the seam, powers `?` auto-conversion |

## Files covered (in order)

1. **`lib.rs`** — crate map; the hard seam; the `pub use` barrel = the whole public API. Seam rule: backend types only inside named conversion points; if it's not re-exported it doesn't exist publicly.
2. **`error.rs`** — `NetError` 3-arm taxonomy (Transport/Protocol/Limit), each wrapping its own enum. `TimeoutKind::Unknown` for `#[non_exhaustive]` backend. `From<ureq::Error>` is the single error conversion point. Statuses never appear (statuses-as-data).
3. **`token.rs` + `method.rs`** — boundary parsing: `is_token_char` (RFC 9110 §5.1) shared by header names and methods; newtype `Method(Token)` with private inner enum + `const` constructors; fetch §2.2.1 normalize table (only 6 verbs uppercased; PATCH exact-case; extensions verbatim); `is_safe` feeds cookie Lax exception.
4. **`header.rs`** — (partially covered) `Vec<Entry>` multimap, not hashmap: duplicates legal, insertion order preserved, case preserved on store, ASCII-case-insensitive lookup. Values are raw `Vec<u8>` (HTTP octets). `impl Into<Vec<u8>>` param. `get_all<'s>` returning `impl Iterator` with lifetime; closures `|e| …` with `move` = capture by value. Validation at insert: token grammar + CTL check = header-injection guard; two rejection latencies (boundary vs backend grammar).

## Next up (proposed order)

1. **`header.rs`** — finish: `remove`/`retain`, wire trace role in `send()` (cookie merge, UA suppression, redirect stripping).
2. **`request.rs`** — the `send()` redirect loop line by line (fragment strip → jar cookie → dispatch → harvest → followable_location → resolve → policy → cap).
3. **`response.rs`** — `Body` streaming, `Box<dyn io::Read + Send>`, RAII cancellation, `from_backend` seam.
4. **`agent.rs`** — builder, ureq config suppression (auto-headers off, redirects off, native-tls), `Arc<Mutex<CookieJar>>`.
5. **Tests** — `send_loopback.rs`, `error_mapping.rs`, `property.rs`, `token_grammar.rs` (public-API-only acceptance, proptest invariants).
6. **Pre-existing (not in diff)** — `cookie.rs`, `dial.rs`, `connector.rs`, `websocket.rs` only if interest continues.

## User feedback history (style guardrails)

- "Dude rewrite the explanation. I'm not that stupid, focus on the code." → code-forward, no basics.
- "go slower please, one by one, one file first" → one file at a time.
- "Easily digestible" → short sections, tables, no walls.
- Likes the format; explicitly asked to learn it into a skill.
