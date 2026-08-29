---
name: reflect
description: "Mines the session for durable learnings and routes each to a concrete edit on an existing skill. Use when the user says reflect, at session end, after notable work or a mid-task correction, or when they ask to update skills. Do not file project facts here; those go to the wiki."
---

# Reflect

Mine the conversation for durable learnings, then land them in skill files. Reviewed and synthesized before anything is written; every accepted learning routes to a concrete edit on an existing skill. A pass that saves nothing is a missed learning, not a neutral outcome.

## When to invoke

- The user said "reflect" or "update skills".
- A complex task (many tool calls) just landed cleanly and the recipe is worth keeping.
- The agent hit dead ends, found the working path, and the path generalizes.
- The user corrected the agent's approach mid-task.
- A non-trivial workflow emerged that isn't captured anywhere.

Skip when the conversation is trivial, off-topic, or already covered by a skill the agent followed correctly. One-offs are not learnings.

## Sources

1. **Current session.** The conversation, tool results, and corrections in context.
2. **A past chat or OpenCode session the user points to.** Sessions live in `~/.local/share/opencode/` storage. If the transcript is not readable as text, write a tight digest of the session and use that instead.
3. **A docs URL** (capture workflow and policy, not marketing) or **a directory** (scan conventions).

## Signals worth capturing

- **Corrections.** You acted on a wrong assumption; the user said "stop doing X", "too verbose", "always Y".
- **Techniques.** A nontrivial fix or debugging path emerged.
- **Conventions.** A rule you would otherwise rediscover.
- **Wrong skills.** A loaded skill missed a step or misled; patch it now.

## Never capture

Environment-specific breakage ("X binary missing"), negative tool claims ("Y is broken"), transient errors, one-off narratives. These harden into false refusals later.

## Process

1. **Read the source fully** before deciding anything.
2. **Review in parallel.** Spawn three read-only subagents in one message, each with the transcript path or digest and one lens:
   - **Judgment.** Where did the agent act on a wrong assumption or misread intent? What would a careful senior do differently?
   - **Tooling.** Which tools, commands, or workflows proved effective or wasted effort? What should the next session use instead?
   - **Divergent.** What is the strongest alternative view? What learning hides in the dead ends and corrections?
   Each returns a short list of candidate learnings with evidence. Subagents never write files; the parent applies all edits.
3. **Synthesize.** Read the three lists yourself and settle what is true across them: **Accepted / Rejected / Backlog**. Rejected candidates keep a one-line reason.
4. **Route to edits.** For each accepted learning, **patch the existing skill that owns the territory**; that is almost always the right home. Add a support file (`references/<topic>.md`, `scripts/<name>`) plus a one-line pointer in its SKILL.md. A new skill only when no existing one covers the class; if the name only fits today's task, fall back to patching.

## Authoring rules

Description is the trigger the agent sees before opening the file. Third person. First sentence: what it does. Second: when, using words the user would type, plus a skip case if overlap is likely. Class-level kebab-case name matching the folder. Exact commands only; never invent flags you did not see. Include a step proving it works.

## Where

Agent-behavior learnings land in skills: global `~/.agents/skills/`, project-only `.agents/skills/` in the repo. Domain knowledge about a project or topic belongs in its wiki instead (`<repo>/wiki/` or `~/wiki`) — route per the `wiki` skill's filing rules.

## Close out

Report what was saved and from which source: skill patched / support file added / each signal skipped with reason. Every captured learning is in a file before stopping.