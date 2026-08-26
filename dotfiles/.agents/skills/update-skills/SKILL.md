---
name: update-skills
description: "Patches skill files from this session's corrections. Use at session end, after the user corrected the agent, or when they ask to update skills. Do not file project facts here; those go to the wiki."
---

# Update Skills

Mine conversations, docs, or directories for what a future session should know differently, then land it in skill files. A pass that saves nothing is a missed learning, not a neutral outcome.

## Sources

- Current chat (session end, after notable work).
- A past chat or OpenCode session the user points to.
- A docs URL (capture workflow and policy, not marketing) or directory (scan conventions).

## Signals worth capturing

- **Corrections.** You acted on a wrong assumption; the user said "stop doing X", "too verbose", "always Y".
- **Techniques.** A nontrivial fix or debugging path emerged.
- **Conventions.** A rule you would otherwise rediscover.
- **Wrong skills.** A loaded skill missed a step or misled; patch it now.

## Never capture

Environment-specific breakage ("X binary missing"), negative tool claims ("Y is broken"), transient errors, one-off narratives. These harden into false refusals later.

## Act in this order

1. Read the source fully before deciding anything.
2. **Patch the existing skill** that owns the territory; that is almost always the right home.
3. Add a support file (`references/<topic>.md`, `scripts/<name>`) plus a one-line pointer in its SKILL.md.
4. New skill only when no existing one covers the class. If the name only fits today's task, fall back to 2 or 3.

## Authoring rules

Description is the trigger the agent sees before opening the file. Third person. First sentence: what it does. Second: when, using words the user would type, plus a skip case if overlap is likely. Class-level kebab-case name matching the folder. Exact commands only; never invent flags you did not see. Include a step proving it works.

## Where

Agent-behavior learnings land in skills: global `~/.agents/skills/`, project-only `.agents/skills/` in the repo. Domain knowledge about a project or topic belongs in its wiki instead (`<repo>/wiki/` or `~/wiki`) — route per the `wiki` skill's filing rules.

## Close out

Report what was saved and from which source: skill patched / support file added / each signal skipped with reason. Every captured learning is in a file before stopping.
