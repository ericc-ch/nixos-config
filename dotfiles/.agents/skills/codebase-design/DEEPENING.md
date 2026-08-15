# Deepening

How to consolidate shallow modules safely, given their dependencies. Assumes standard design concepts: **module**, **interface**, **boundary**, **adapter**.

## Dependency categories

When assessing a candidate for consolidation, classify its dependencies. The category determines how the module is tested across its public interface.

### 1. In-process

Pure computation, in-memory state, no I/O. Always safe to deepen — merge the modules and test through the new interface directly. No adapter needed.

### 2. Local-substitutable

Dependencies that have local test stand-ins (PGLite for Postgres, in-memory filesystem). Deepen it if the stand-in exists. The deepened module is tested with the stand-in running in the test suite. The implementation details remain internal; no port needed at the module's external interface.

### 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary (microservices, internal APIs). Define a clean interface at the boundary. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter. Production uses an HTTP/gRPC/queue adapter.

Recommendation shape: *"Define an interface at the boundary, implement an HTTP adapter for production and an in-memory adapter for testing, so the logic sits in one deep module even though it's deployed across a network."*

### 4. True external (Mock)

Third-party services (Stripe, Twilio, etc.) you don't control. The deepened module takes the external dependency as an injected port; tests provide a mock adapter.

## Interface discipline

- **Do not add abstractions prematurely:** Don't introduce an interface layer unless there are multiple implementations or concrete testing requirements (e.g. production + test fake). A single-implementation interface without testing variation is often unnecessary indirection.
- **Public vs internal boundaries:** Keep internal helpers and private module logic encapsulated. Only expose what callers actually need.

## Testing strategy: replace, don't layer

- Old unit tests on shallow modules become waste once tests at the deepened module's interface exist — delete them.
- Write new tests at the deepened module's interface. The **interface is the test surface**.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors — they describe behavior, not implementation. If a test has to change when the implementation changes, it's testing past the interface.
