---
name: to-spec
description: Turn the current conversation into a spec at .scratch/<feature>/spec.md.
---

# To Spec

Summarize what was already decided into a feature spec. Do not interview the user again.

Write the file in the **current project**:

`.scratch/<feature-slug>/spec.md`

Create the folder if needed. Do not use GitHub Issues. No setup step.

Steps:

1. Read the relevant code and ADRs.
2. Prefer tests at public APIs or major interfaces, not private details.
3. Write `spec.md` using this shape:

```markdown
# <Feature name>

Problem: <from the user's point of view>

Solution: <from the user's point of view>

User stories:

1. As a <actor>, I want <feature>, so that <benefit>.

Implementation decisions:

- <module / API / schema / architecture choice>

Testing decisions:

- <high-level boundary to test>
- <suite to add or extend>

Out of scope:

- <excluded idea>

Notes:

- <optional references>
```

Do not list brittle file paths or line numbers that will go stale.
