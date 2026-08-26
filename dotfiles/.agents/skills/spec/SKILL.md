---
name: Spec
description: Turn the current conversation into a spec at wiki/work/<feature>/spec.md. Use after a grilling or planning discussion when the user says "write the spec" or "spec this".
---

# Spec

Synthesize what was already decided into a feature spec. Do not interview again; the conversation is the source.

Write to `<repo>/wiki/work/<feature-slug>/spec.md`. Create folders as needed.

## Steps

1. Read the relevant code and any ADRs so decisions land in real context.
2. Write `spec.md` in this shape:

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

Do not list brittle file paths or line numbers that will go stale. Name modules and contracts instead.

Next step when the user wants it sliced: `tickets`.
