# Codebase design

Shared vocabulary for designing deep modules. Use these words exactly when discussing shape. Do not drift into "component", "service", "API", or "boundary".

## Vocabulary

- **Module:** anything with an interface and an implementation. A function, class, package, or a slice across tiers.
- **Interface:** everything a caller must know to use the module. Types, invariants, ordering constraints, error modes, required configuration, and performance.
- **Implementation:** the code inside the module.
- **Depth:** leverage at the interface. A deep module hides a lot of behavior behind a small surface. A shallow module's interface is nearly as complex as its implementation.
- **Seam:** the place where the interface lives, where behavior can change without editing the callers.
- **Adapter:** a concrete thing that satisfies an interface at a seam. It describes a role, not what is inside.
- **Leverage:** what callers get from depth. More capability per unit of interface they learn.
- **Locality:** what maintainers get from depth. Change, bugs, knowledge, and verification concentrate in one place.

## Deep vs shallow

A deep module has a small interface and substantial behavior behind it.

```text
┌─────────────────────┐
│   Small interface   │  few methods, simple parameters
├─────────────────────┤
│                     │
│  Deep implementation│  the behavior callers do not see
│                     │
└─────────────────────┘
```

A shallow module has a large interface and little hidden behavior.

```text
┌─────────────────────────────────┐
│        Large interface          │  many methods, complex parameters
├─────────────────────────────────┤
│      Thin implementation        │  mostly passes through
└─────────────────────────────────┘
```

When you design an interface, ask:

- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity behind the seam?

## Principles

- **Depth is a property of the interface, not the implementation.** A deep module can be built from small parts. They just are not part of the interface.
- **The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam. A test that needs to reach past the interface means the module is the wrong shape.
- **One adapter means a hypothetical seam. Two adapters means a real one.** Do not add a seam unless something actually varies across it.
- **Internal seams stay internal.** A module can have private seams for its own tests. Do not expose them through the interface.

## Design it twice

The first shape is unlikely to be the best. Write at least two structurally distinct candidates before choosing. Not two variations of one shape.

For each candidate:

1. The caller's view first. Show the smallest realistic usage example.
2. The types, signatures, and module boundaries.
3. What the interface hides and what it exposes.
4. Where the seam goes and what sits behind it.
5. The trade-offs, in terms of leverage and locality.

Compare the candidates on depth, locality, and seam placement. Prefer the one that hides more complexity behind a smaller surface. Prefer the one where an agent that sees only one file makes the right change.

## Designing for testability

- **Accept dependencies, do not create them.** Pass the gateway in. Do not construct it inside the module.
- **Return results, do not produce side effects.** A pure function is easier to test than one that mutates a caller's object.
- **Keep the surface small.** Fewer methods means fewer tests and simpler setup.

## Seams and dependencies

Classify the dependency before you deepen the module:

- **In-process:** pure computation or in-memory state. Merge the modules and test through the new interface.
- **Local substitute:** has a local stand-in, such as PGLite for Postgres. Test with the stand-in.
- **Remote but owned:** your own service across a network. Define a port at the seam, with a production adapter and an in-memory adapter for tests.
- **True external:** a third-party service you do not control. Inject a port and use a mock adapter in tests.

## Red flags

Screen every candidate before choosing. A red flag is a reason to revise or reject the shape.

- **Shallow module:** callers coordinate several methods for one operation, public options expose internal stages, or learning the interface does not save the caller from learning the implementation.
- **Information leakage:** a representation, policy, or protocol detail appears in more than one module. Public re-exports of transport or wire types are leakage.
- **Temporal decomposition:** modules are organized by execution order (load, validate, transform, save) instead of the knowledge they own. The same invariants get repeated across boundaries.
- **Pass-through method:** forwards the same arguments to another method with the same shape. It adds a layer and hides nothing.
- **Split ownership:** more than one module writes the same state. Give each piece of state one owner.
- **Two ways to do one task:** the design supports more than one path. An agent copies whichever it finds first. Keep one path and delete the others in the same change.
- **Importable internals:** a caller can import the internals. Make them unreachable so the import fails the build.
- **Hand-synced list:** the same items appear in two places. Keep one list and derive the other, or fail the build when they disagree.

## Rejected framings

- **Depth as the ratio of implementation lines to interface lines.** It rewards padding the implementation. Use depth as leverage instead.
- **"Interface" as the TypeScript `interface` keyword or a class's public methods.** Too narrow. Interface here includes every fact a caller must know.
- **"Boundary".** It is overloaded with DDD's bounded context. Say **seam** or **interface**.
