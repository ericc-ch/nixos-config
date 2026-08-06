---
name: self-learn
description: Extract durable skills from a finished conversation. Use at session end or after notable work.
---

# Self-Learn

Review the conversation for skill-worthy learnings and save them as skills. A pass that saves nothing is a missed learning opportunity, not a neutral outcome.

## Signals

Any one of these warrants action:

- **Corrections.** The user corrected your style, tone, format, or workflow. Frustration is a strong signal: "stop doing X", "too verbose", "don't format like this", "you always do Y and I hate it".
- **Techniques.** A non-trivial fix, workaround, or debugging path emerged that a future session would benefit from.
- **Wrong skills.** A skill loaded or consulted this session turned out wrong, missing a step, or outdated. Patch it now.

## Do NOT capture

These harden into constraints that bite later when the environment changes:

- Environment-dependent failures: missing binaries, uninstalled packages, unconfigured credentials.
- Negative tool claims: "X is broken", "cannot use Y". These become refusals the agent cites long after the problem is fixed.
- Transient errors that resolved before the session ended.
- One-off task narratives: a single task is not a class of work.
- Unresolved failures dressed up as validated guidance.

## Act in this order

1. **Patch an existing skill** that covers the learning's territory. The skill in play is the right home.
2. **Add a support file** under an existing skill: `references/<topic>.md` for session-specific detail, `scripts/<name>` for re-runnable work. Add a one-line pointer in SKILL.md.
3. **Create a new class-level skill** only when nothing existing covers the class. A name that only fits today's task is wrong — fall back to 1 or 2.

## Ask the user where to land

- **Global** — `~/.agents/skills/` (the default; what most people use).
- **Project-local** — `./.agents/skills/` in the current project.

In this repo, `~/.agents` is a nix-store path: writes work now but only survive through `config/agents/skills/` plus a rebuild.

## Authoring

Follow the `writing-for-agents` skill. In particular:

- Description is the trigger: state the capability, front-load the leading word, keep it short enough to survive the loader's truncation window.
- Class-level scope, lowercase-hyphenated name, no PR numbers or error strings.
- Include a verification step that proves the skill works.
- Exact commands only — never invent flags or APIs you did not see in the conversation.

## Completion

Report what you saved: skill patched or created, support file added, or each signal skipped with its reason. Every captured learning must be in a file before you stop.
