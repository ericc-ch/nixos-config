---
name: reflect
description: "Captures lasting lessons and patches existing skills. Use when the user says reflect, at session end, or after notable work or a correction."
---

Pull lasting lessons from a session, then edit skill files to keep them. Nothing is written before review, and each accepted lesson becomes one concrete edit to an existing skill. A pass that saves nothing counts as a miss, not a neutral result.

## Source

Ask the user where to pull the lessons from. The conversation is the default. Read the whole source before deciding anything.

## Signals worth capturing

- A correction: you acted on a wrong assumption, or the user said "stop doing X", "too verbose", "always Y".
- A technique: a fix or debugging path that was not obvious.
- A convention: a rule you would otherwise rediscover next time.
- A wrong skill: a loaded skill missed a step or misled. Patch it during this pass.

## Never capture

Skip one-off signals: environment breakage ("X binary missing"), claims that a tool is broken, transient errors, and stories tied to this one task. Written down, they become rules that misfire later.

## Process

1. Spawn one read-only subagent. Give it the source, either the path the user gave or a digest you wrote of the conversation, because subagents cannot see the conversation. Ask it to return a short list of candidate lessons with evidence, covering:
   - Judgment: where did the agent act on a wrong assumption or misread the user? What would a careful senior do differently?
   - Tooling: which tools, commands, or workflows helped or wasted time? What should the next session use instead?
   - Divergent: what is the strongest other view? What lesson hides in the dead ends?
   The subagent never writes files. You apply all edits.
2. Read its list yourself and settle what holds up: accepted, rejected, or backlog. Rejected lessons keep a one-line reason.
3. For each accepted lesson, patch the skill that covers the topic. That is almost always the right home. If the lesson needs more room, add a support file (`references/<topic>.md` or `scripts/<name>`) and a one-line pointer in the SKILL.md. Make a new skill only when no existing one covers the topic. If the name only fits today's task, patch an existing skill instead.
32: 
33: ## Authoring rules
34: 
35: - The description is the trigger. The agent reads it before opening the file. Write it in third person. In the first sentence, describe what the skill does. In the second sentence, state when to use it using words the user would type. Add a skip case when another skill overlaps.
36: - Match the kebab-case name to the folder.
37: - Use only commands you have seen work. Never invent flags.
38: - Include a step that proves the change works.
39: 
40: ## Where
41: 
42: Save agent behavior into skills: `~/.agents/skills/` for global skills, and `.agents/skills/` in the repository for project skills. Put project facts and domain terms into `docs/CONTEXT.md` instead.
43: 
44: ## Close out
45: 
46: Report what you saved: each skill patched, each support file added, and each skipped signal with a reason. Save every accepted lesson to a file before you stop.
