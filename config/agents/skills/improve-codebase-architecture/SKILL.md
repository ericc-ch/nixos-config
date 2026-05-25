---
name: improve-codebase-architecture
description: Load this skill when the user wants to improve architecture, find refactoring opportunities, or make a codebase more testable and AI-navigable.
---

# Improve Codebase Architecture

Identify areas of the codebase that are messy, hard to maintain, or difficult to test, and propose ways to hide complex details behind simple, clean interfaces.

## Vocabulary

Use these core concepts internally to guide your reasoning. However, **when talking to the user, always translate them into simple, plain-English terms** (e.g., say "connecting point" or "boundary" instead of "seam", and "hiding details" instead of "deepening").

- **Module** — Any self-contained piece of code (like a function, a class, a file, or a directory).
- **Interface** — What a developer needs to know to use a module (its parameters, settings, rules, and what it returns).
- **Implementation** — The actual code inside the module that does the work.
- **Depth (Deep vs. Shallow)** —
  - **Deep Module** = Hides complex details behind a very simple interface (high value).
  - **Shallow Module** = The interface is almost as complex as the code inside it, meaning it doesn't hide complexity and is mostly just a middleman (low value).
- **Seam** (Boundary/Connection Point) — A place in the code where we can swap out how a module works without modifying the callers (e.g., using an interface to swap a real database with a fake database for testing).
- **Adapter** — The actual code that runs behind a seam (e.g., the real database helper vs. the mock database helper).
- **Leverage** — How much work a module does for you compared to how easy it is to use.
- **Locality** — Keeping related logic, bugs, and changes in one single place.

## Core Principles

- **Focus on the Interface, Not the Size**: A module can be large or small, but its interface should always remain simple. Any internal boundaries or helper functions inside the module should stay private.
- **The Deletion Test**: If you delete a module, does its complexity disappear completely? If yes, it was a good module. If its complexity just gets scattered across other files that called it, the module was a "pass-through" (shallow middleman) and should be merged.
- **Test at the Boundaries**: Write tests against the public interface, not the internal code. This ensures tests don't break when you clean up or refactor the inner code.
- **Don't Over-Engineer**: Do not create a seam (interface) unless you have at least two actual uses for it (like one for production and one for testing). One adapter is just a guess; two adapters make a real boundary.

## Process

### 1. Find Messy Code (Explore)

Look for these code issues:

- Does understanding one simple feature require bouncing across many tiny files?
- Are there **shallow** modules that don't actually hide any complexity?
- Did we extract pure functions just for tests, while leaving the main bugs scattered across the app (poor **locality**)?
- Are different parts of the code tightly coupled or leaking details to each other?
- Are there parts of the code that are completely untested or hard to test?

Use the **Deletion Test** to check if suspicious modules are worth keeping.

### 2. Propose Improvements to the User

Present a numbered list of candidates to simplify. **Use simple language. Do not use jargon like "locality", "seams", "adapters", or "deepening" in your explanations.**

For each candidate, provide:

- **Files** — The files or modules involved.
- **Problem** — Why the current code is hard to work with or test.
- **Solution** — A plain-English explanation of how we will change the code to hide complexity.
- **Benefits** — How this makes the code easier to change, test, and maintain.

Do **not** show code interfaces yet. End with: **"Which of these would you like to explore?"**

### 3. Clarification & Design Loop

Once the user selects a candidate, interview them with friendly, step-by-step questions to clarify:

- Any database, network, or external constraints.
- How the new module should behave.
- What parts need to be swapped out during testing.
- Which existing tests we want to keep or replace.

## Handling Dependencies (Database, Network, APIs)

Classify dependencies before deciding how to test them:

1. **In-Process** (Pure code / In-memory data): No databases or networks. Merge them and test directly through the public interface.
2. **Local-Substitutable** (Local stand-ins): You can run a local replacement (like an in-memory database or a mock file system). Use the local stand-in for tests; keep the boundary internal.
3. **Remote but Owned** (Your other services): Services you control across the network. Create an interface (seam) with a real network adapter for production, and an in-memory adapter for testing.
4. **True External** (Third-party APIs): APIs you don't control. Create an interface (seam) and use a mock adapter in tests.

**Testing Rule**: Test real outcomes through the interface. When you write new, robust interface-level tests, delete the old, fragile unit tests that were testing internal helper functions.

## Designing the Interface (Optional)

If the user wants to design the interface:

1. **Frame the Problem**: Describe the goal and constraints in simple terms. Show a rough sketch to make sure you and the user are on the same page.
2. **Propose the Best Approach**: Recommend a design that provides the deepest module (hiding the most complexity behind the simplest interface). Show what the interface will look like and how it will be used.
3. **Explain the Rationale**: Clearly explain why this design is the best choice, how it simplifies the system, and how we will test it.
