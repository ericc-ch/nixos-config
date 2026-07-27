---
name: codebase-design
description: Design principles for creating clean, deep modules.
---

# Codebase Design

Design software around simple, maintainable module interfaces.

## Definitions

- **Module:** Any unit of code (function, class, package) with an interface and implementation.
- **Interface:** The public surface callers use to interact with a module.
- **Deep Module:** A module with a small, simple interface hiding substantial internal logic.
- **Shallow Module:** A module with a large interface that does very little work (avoid this).

---

## Design Principles

1. **Aim for deep modules:** Hide complex implementation details behind small interfaces with few methods and simple parameters.
2. **Design for testability:**
   - Pass dependencies as arguments instead of creating them internally.
   - Return outputs from functions rather than mutating global state.
   - Test modules through their public interfaces.
3. **Keep test boundaries stable:** Make sure refactoring internal code does not break tests as long as public behavior is unchanged.
