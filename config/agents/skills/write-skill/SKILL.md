---
name: write-skill
description: Load this skill when authoring or iterating on Agent Skills (SKILL.md), skill layout, evaluation workflows, or skill-trigger tuning.
---

Help the user progress through **skill creation**: clarify intent → draft `SKILL.md` → run test prompts → evaluate (qualitative and/or quantitative) → revise → repeat → optionally expand tests. Meet them wherever they are (idea only, draft ready, or iteration). If they want a lighter pass (“just vibe”), skip heavy evals. After the skill feels done, you may tighten the **description** field for better triggering.

## Communicating with the user

Audiences range from minimal jargon to technical. Default wording: “evaluation” / “benchmark” are fine; use terms like “JSON” or “assertion” without explanation only if context shows they’re comfortable. When unsure, give a one-line definition.

## Creating a skill

### Capture intent

If the chat already describes a workflow (“turn this into a skill”), mine it first: tools, step order, corrections, I/O shapes—then have the user confirm gaps.

1. What should the skill let the agent do?
2. When should it trigger (phrases / contexts)?
3. Expected output shape?
4. Test cases? Objective outputs (transforms, extraction, codegen, fixed steps) usually benefit; subjective outputs (tone, art) often don’t—recommend, user decides.

### Interview and research

Ask about edge cases, formats, examples, success criteria, dependencies. **Don’t** draft test prompts until this is clear. Research in parallel when it reduces user load.

### Write `SKILL.md`

- **`name`:** identifier.
- **`description`:** Primary trigger signal—**both** what it does **and** when to use it; put “when to use” here, not only in the body. Skills tend to **under-trigger**; write descriptions slightly **pushy** (e.g. mention dashboards, viz, metrics—not only the word “dashboard”).
- **`compatibility`:** tools/deps—optional, rarely needed.
- **Body:** the actual instructions.

## Skill writing guide

### Layout

```
skill-name/
├── SKILL.md          # YAML frontmatter + markdown
└── (optional)
    ├── scripts/      # deterministic / repetitive automation
    ├── references/   # docs loaded on demand
    └── assets/       # templates, fonts, icons, etc.
```

Frontmatter must include at least `name` and `description`.

### Intent and safety

Instructions must match stated intent: no malware, exploits, or deceptive guidance. Refuse skills aimed at unauthorized access, exfiltration, or harm. Benign roleplay-style skills are fine.

### Patterns

- Prefer **imperative** instructions.
- **Fixed output shapes:** give an explicit template (`ALWAYS use this exact structure …`).
- **Examples:** label clearly (e.g. Input / Output) so the model can mimic format.

### Style

Explain **why** constraints exist; aim for general guidance, not one-off examples. Draft, then tighten.

### Triggering and evals

The agent sees `name` + `description` in `available_skills` and loads a skill when the task benefits from it. **Simple one-step** tasks may never load a skill even if the description matches. **Eval prompts** should be substantive enough that consulting the skill actually helps—avoid trivial tests like “read file X.”

### Iteration loop (summary)

Intent → draft → run prompts → review with user → revise → repeat → ship; widen tests when appropriate.
