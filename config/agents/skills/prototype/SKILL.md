---
name: prototype
description: Build a quick throwaway prototype to answer a design or UI question.
---

# Prototype

Build throwaway code to test a specific design question.

## Core Rules

1. **Throwaway code:** Name prototype files clearly (e.g. `prototype-foo.ts`) so they are clearly separate from production code.
2. **Keep state in memory:** Do not set up databases or persistent storage unless testing storage logic specifically.
3. **One command to run:** Make the prototype executable via a single CLI command (`pnpm run prototype`, `python prototype.py`, etc.).
4. **Skip production polish:** Do not write unit tests, complex error handling, or extra abstractions. Focus purely on answering the design question.
5. **Clean up when done:** Save your validated decision in your spec or commit message, then remove or archive prototype code.
