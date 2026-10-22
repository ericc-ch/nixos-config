---
name: sharpen-skills
description: "Turns lasting lessons from a session into skill edits. Use when the user says remember this, never do X again, or at session end after corrections. Skip repo fixes a check could catch, use `harden-repo` instead."
---

Pull lasting lessons from a session and edit skill files to keep them. Nothing is written before review. Each accepted lesson becomes one concrete edit to an existing skill. If a pass saves nothing, it failed.

## Source

Ask the user where to take the lessons from. The conversation is the default. Read the whole source before deciding anything.

## Lessons worth saving

- A correction: you acted on a wrong assumption, or the user said "stop doing X", "too verbose", or "always Y".
- A technique: a fix or debugging path that was not obvious.
- A convention: a rule you would otherwise have to learn again next time.
- A wrong skill: a loaded skill missed a step or misled you. Fix it in this pass.

## Do not save

Skip one-off signals: a broken environment ("X binary missing"), claims that a tool is broken, transient errors, and details tied to this one task. Written down, they become rules that misfire later. Skip repo problems that belong in `harden-repo`: a long search, a repeated mistake a check could catch, a missing log or access. Send that case to `harden-repo` and save nothing here.

## Process

1. Review the source: read the conversation or the source you were given. Find lessons backed by evidence:
   - Judgment: where did you act on a wrong assumption or misread what the user wanted? What would a careful senior do instead?
   - Tooling: which tools, commands, or workflows helped or wasted time? What should the next session use instead?
   - Other view: what is the strongest opposite take? What did the dead ends teach?
2. Read the list and decide what holds up: accepted, rejected, or deferred. Rejected lessons get a one-line reason.
3. For each accepted lesson, edit the skill that covers the topic. That is almost always the right place. If the lesson needs more room, add a support file (`references/<topic>.md` or `scripts/<name>`) and a one-line pointer in SKILL.md. If the lesson needs a repo check, pointer, or reviewer rule instead of a behavior change, send it to `harden-repo` and change nothing here. Create a new skill only when no existing one covers the topic. If the name fits only today's task, edit an existing skill instead.

## Writing rules

- The description decides when the skill loads. Write it in third person. In the first sentence, say what the skill does. In the second, say when to use it, in words the user would type. Add a skip case when another skill overlaps.
- Match the kebab-case name to the folder.
- Use only commands you have seen work. Never invent flags.
- Include a step that proves the change works.
- Write the skill in simple English. Use short sentences, plain words, and complete grammar.

## Where

Save agent behavior in skills: `~/.agents/skills/` for global skills, and `.agents/skills/` in the repo for project skills.

## Finish

Report what you saved: each skill edited, each support file added, and each skipped signal with a reason. Save every accepted lesson to a file before you stop.
