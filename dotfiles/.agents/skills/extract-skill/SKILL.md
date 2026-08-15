---
name: extract-skill
description: Extract durable skills from a conversation, docs site, or directory. Use at session end, after notable work, or when the user points at a source to learn from.
---

# Extract

Turn skill-worthy learnings from any source into skills. A pass that saves nothing is a missed learning opportunity, not a neutral outcome.

## Sources

- **Conversation** — the current chat, at session end or after notable work.
- **User-described** — the user points at a source: a past chat, a docs site (URL), a directory, or a file.
- **Docs site** — a URL. Read it first; capture workflow, convention, and policy, not product marketing.
- **Directory / file** — scan for patterns, conventions, and policies a future session should follow.

For broad sources (a whole docs site or repo), confirm the scope with the user before extracting. Prefer targeted extraction over an exhaustive research pass.

## Signals

Any one of these warrants action:

- **Corrections.** A source contradicts an assumption you would have acted on — style, tone, format, or workflow. Frustration is a strong signal: "stop doing X", "too verbose", "you always do Y".
- **Techniques.** A non-trivial fix, workaround, or debugging path emerged. A future session would benefit.
- **Conventions.** The source states a rule, format, or workflow you would otherwise rediscover.
- **Wrong skills.** A skill you loaded or consulted turned out wrong, missing a step, or outdated. Patch it now.

## Do NOT capture

These harden into constraints that bite later when the environment changes:

- Environment-dependent failures: missing binaries, uninstalled packages, unconfigured credentials.
- Negative tool claims: "X is broken", "cannot use Y". These become refusals the agent cites long after the problem is fixed.
- Transient errors that resolved before the pass finished.
- One-off narratives: a single task is not a class of work.
- Unresolved failures dressed up as validated guidance.

## Act in this order

1. **Read the source first.** Skim the docs, scan the directory, or review the conversation before deciding what to capture.
2. **Patch an existing skill** that covers the learning's territory. The skill in play is the right home.
3. **Add a support file** under an existing skill: `references/<topic>.md` for source-specific detail, `scripts/<name>` for re-runnable work. Add a one-line pointer in SKILL.md.
4. **Create a new class-level skill** only when nothing existing covers the class. A name that only fits today's source is wrong — fall back to 2 or 3.

## Where to land

- **Global** — `~/.agents/skills/` (the default; what most people use).
- **Project-local** — `./.agents/skills/` in the current project.

## Authoring

Follow the `writing-for-agents` skill. In particular:

- Description is the trigger: state the capability clearly, start with the main action keyword, and keep it concise.
- Class-level scope, lowercase-hyphenated name, no PR numbers or error strings.
- Include a verification step that proves the skill works.
- Exact commands only — never invent flags or APIs you did not see in the source.

## Completion

Report what you saved and from which source: skill patched or created, support file added, or each signal skipped with its reason. Every captured learning must be in a file before you stop.
