---
name: improve-codebase-architecture
description: Load this skill when the user wants to improve architecture, find refactoring opportunities, or make a codebase more testable and AI-navigable.
---

# Improve Codebase Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. Aim: testability and AI-navigability.

## Vocabulary

Use these terms exactly in every suggestion. Don't drift into "component," "service," "API," or "boundary."

- **Module** — anything with an interface and implementation (function, class, package, slice).
- **Interface** — everything a caller must know: types, invariants, error modes, ordering, config — not just the signature.
- **Implementation** — code inside the module.
- **Depth** — leverage at the interface: much behaviour behind a small surface. **Deep** = high leverage; **shallow** = interface nearly as complex as the implementation.
- **Seam** — where the interface lives; behaviour can change without editing in place.
- **Adapter** — concrete thing satisfying the interface at a seam.
- **Leverage** — what callers get from depth.
- **Locality** — what maintainers get: change, bugs, knowledge concentrated in one place.

**Principles**

- Depth is a property of the **interface**, not line count. Internal seams are fine; they stay private.
- **Deletion test**: delete the module. Complexity vanishes → pass-through. Complexity reappears across callers → it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam.
- **One adapter = hypothetical seam. Two adapters = real seam.** Don't add ports without production + test (or similar) adapters.

## Process

### 1. Explore

Note friction organically:

- Understanding one concept requires bouncing across many small modules?
- **Shallow** modules — interface nearly as complex as the implementation?
- Pure functions extracted for testability while real bugs hide in call patterns (no **locality**)?
- Tightly-coupled modules leaking across seams?
- Untested or hard-to-test areas?

Apply the **deletion test** to suspected shallow modules.

### 2. Present candidates

Numbered list of deepening opportunities. Per candidate:

- **Files** — modules involved
- **Problem** — why the current shape hurts
- **Solution** — plain-English change
- **Benefits** — locality, leverage, how tests improve

Do **not** propose interfaces yet. Ask: **"Which of these would you like to explore?"**

### 3. Grilling loop

Once the user picks a candidate, interview them through the design tree — constraints, dependencies, shape of the deepened module, what sits behind the seam, which tests survive.

## Deepening by dependency type

Classify dependencies before proposing how to test across the seam:

1. **In-process** — pure computation, in-memory state, no I/O. Merge and test through the new interface directly.
2. **Local-substitutable** — local stand-ins exist (PGLite, in-memory FS). Deepen with stand-in in tests; seam stays internal.
3. **Remote but owned** — your services across the network. Port at the seam; HTTP/gRPC/queue adapter in prod, in-memory adapter in tests. Logic lives in one deep module.
4. **True external** — third parties you don't control. Injected port; mock adapter in tests.

**Testing:** replace, don't layer. Delete old shallow unit tests once interface-level tests exist. Assert observable outcomes through the interface; tests survive internal refactors.

## Interface design (optional)

When exploring alternative interfaces for a chosen candidate ("Design It Twice"):

**1. Frame** — User-facing problem space: constraints, dependency category (above), rough sketch (illustrative, not a proposal). Show the user, then proceed.

**2. Explore** — 3+ different alternatives. Each gets a different constraint:

- Minimize the interface (1–3 entry points, max leverage).
- Maximize flexibility / extension.
- Optimize the common caller path.
- (If needed) Ports & adapters for cross-seam deps.

**3. Compare** — Present designs sequentially, then compare by depth, locality, seam placement. Give an opinionated recommendation or hybrid; don't leave a flat menu.
