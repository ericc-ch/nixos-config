---
name: improve-codebase
description: Identify and execute architectural refactors to turn shallow modules into deep ones. Use this skill when scanning the codebase for deepening opportunities, presenting them in chat, and walking through the design loop for a selected candidate.
---

# Improve Codebase Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

## Vocabulary & Tone

Use these core concepts to guide your reasoning. When explaining concepts to the user, use clear, simple language and ensure you explain terms in plain English. Do not let technical jargon obscure the clarity of your explanation.

- **Module** — Any self-contained piece of code (like a function, a class, a file, or a directory).
- **Interface** — What a developer needs to know to use a module (its parameters, settings, rules, and what it returns).
- **Implementation** — The actual code inside the module that does the work.
- **Depth (Deep vs. Shallow)** —
  - **Deep Module** = Hides complex details behind a very simple interface (high value).
  - **Shallow Module** = The interface is almost as complex as the code inside it, meaning it doesn't hide complexity and is mostly just a middleman (low value).
- **Seam** — A place in the code where we can swap out how a module works without modifying the callers.
- **Adapter** — The actual code that runs behind a seam.
- **Leverage** — How much work a module does for you compared to how easy it is to use.
- **Locality** — Keeping related logic, bugs, and changes in one single place.

### Tone Guidelines
Use simple, plain English when communicating with the user. While you should use architectural vocabulary (module, interface, implementation, depth, deep, shallow, seam, adapter, leverage, locality) to maintain architectural precision, explain them in clear, simple terms rather than relying on abstract jargon.

Prefer these architectural terms over generic substitutes:
- Use **module** instead of *component*, *service*, or *unit*.
- Use **interface** instead of *API* or *signature*.
- Use **seam** instead of *boundary*.
- Use **adapter** when describing implementation behind a seam.

## Core Principles

- **Focus on the Interface, Not the Size**: A module can be large or small, but its interface should always remain simple. Any internal boundaries or helper functions inside the module should stay private.
- **The Deletion Test**: If you delete a module, does its complexity disappear completely? If yes, it was a good module. If its complexity just gets scattered across other files that called it, the module was a "pass-through" (shallow middleman) and should be merged.
- **Test at the Boundaries**: Write tests against the public interface, not the internal code. This ensures tests don't break when you clean up or refactor the inner code.
- **Don't Over-Engineer**: Do not create a seam (interface) unless you have at least two actual uses for it (like one for production and one for testing). One adapter is just a guess; two adapters make a real boundary.

## Process

### 1. Explore

Read the project's domain glossary (such as `CONTEXT.md`) and any architecture decision records (ADRs) first.

Then, use subagents to explore the codebase to walk the project organically. Note where you experience friction:
- Where does understanding one concept require bouncing between many small modules?
- Where are modules **shallow** (interface nearly as complex as the implementation)?
- Where have pure functions been extracted just for testability, but the real bugs hide in how they're called (no **locality**)?
- Where do tightly-coupled modules leak across their seams?
- Which parts of the codebase are untested or hard to test through their current interface?

Apply the **deletion test** to check if suspicious modules are worth keeping: would deleting it concentrate complexity, or just move it?

### 2. Present Candidates

Present the candidates directly in the chat using Markdown. Do not generate an HTML file or write to `/tmp`.

For each candidate, render:
- **Title** — short, names the deepening (e.g., "Collapse the Order intake pipeline").
- **Metadata** — recommendation strength (`Strong`, `Worth exploring`, `Speculative`) and a tag for the dependency category (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files** — monospaced list of files/modules involved.
- **Before / After Diagram** — Side-by-side or stacked text-based diagrams using **Mermaid code blocks** (` ```mermaid `) or text art to visualize the shallowness and the deepening.
- **Problem** — one sentence. What hurts.
- **Solution** — one sentence. What changes.
- **Wins** — bullet points of <=6 words each, naming the gain in glossary terms (e.g., "locality: bugs concentrate in one module", "leverage: one interface, N call sites", "interface shrinks; implementation absorbs wrappers").
- **ADR callout** (if applicable) — one line in a warning block if the candidate contradicts or affects an existing ADR.

No paragraphs of explanation. Concision is key; let the diagrams and structured fields carry the weight.

End the candidates list with a **Top Recommendation** section: candidate name, one sentence on why, and a reference/link to its description.

Do NOT propose interface code yet. Ask the user: **"Which of these would you like to explore?"**

### 3. Clarification & Design Loop

Once the user picks a candidate, run a clarification loop to walk the design details:
- Identify constraints, dependencies, and the shape of the deepened module.
- Define what sits behind the seam and what tests survive.
- If you need to explore alternative interfaces or run parallel designs, use subagents to help design-it-twice.
- Keep the domain glossary updated if new terms are introduced or clarified.
